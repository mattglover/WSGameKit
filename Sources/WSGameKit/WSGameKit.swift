import Foundation

public typealias WSGameId = String

public protocol WSGameKitSendDelegate: AnyObject {
    func sendMesage(_: WSMessage, toPlayerIds: [String])
}

public class WSGameKit {
    
    public weak var sendDelegate: WSGameKitSendDelegate?
    
    private(set) var games = [String: WSGame]()
    public static let defaultBoardSize = 15
    private let jsonDecoder = JSONDecoder()
    
    public var availableGameIds: [String] {
        let gamesWithAvailability = games.values.filter( {$0.guestPlayers.count < 5} )
        let keys = gamesWithAvailability.map( {$0.gameId} )
        return keys
    }
    
    public init() {}
    
    public func handleFromClientCommand(_ commandString: String) {
        
        guard let data = commandString.data(using: .utf8) else { return }
        guard let command = try? jsonDecoder.decode(WSCommand.self, from: data) else { return }
        
        switch command.type {
        case .setup:
            handleSetupCommand(command.command, playerId: command.playerId, gameId: command.gameId)
        case .start:
            handleStartCommand(gameId: command.gameId)
        case .move:
            handleMoveCommand(command.command, playerId: command.playerId, gameId: command.gameId)
        case .info:
            handleInfoCommand(command.command, playerId: command.playerId, gameId: command.gameId)
        }
    }
    
    private func handleSetupCommand(_ string: String, playerId: String, gameId: WSGameId?) {
        switch string {
        case "n":
            let game = self.newGame(withPlayer: playerId, boardSize: WSGameKit.defaultBoardSize, delegate: self)
            sendMessage(WSMessage(type: .currentGameId, message: game.gameId), toPlayerIds: [playerId])
        case "j":
            if let gameId = gameId {
                self.joinGame(gameId: gameId, playerId: playerId)
            }
        default:
            break
        }
    }
    
    private func handleStartCommand(gameId: String?) {
        guard let gameId = gameId, let game = games[gameId], game.canStart else { return }
        game.startGame()
    }
    
    private func handleMoveCommand(_ string: String, playerId: String, gameId: WSGameId?) {
        guard let gameId = gameId, let game = games[gameId] else { return }
        game.handleCommand(command: string, playerId: playerId)
    }
    
    private func handleInfoCommand(_ string: String, playerId: String, gameId: WSGameId?) {
        switch string {
        case "av":
            let message = WSMessage(type: .availableGameIdsRequest, messageCollection: availableGameIds)
            sendMessage(message, toPlayerIds: [playerId])
        default:
            break
        }
    }
    
    private func sendMessage(_ message: WSMessage, toPlayerIds playerIds: [String]) {
        if let sendDelegate = sendDelegate {
            sendDelegate.sendMesage(message, toPlayerIds: playerIds)
        }
    }
}

extension WSGameKit: WSGameDelegate {
    public func gameDidUpdate(_ game: WSGame) {
        let message = WSMessage(type: .gameUpdate, message: game.gameState)
        sendMessage(message, toPlayerIds: game.playerIds)
    }
}


// Setup Commands
extension WSGameKit {
    private func newGame(withPlayer playerId: String, boardSize: Int = WSGameKit.defaultBoardSize, delegate: WSGameDelegate? = nil) -> WSGame {
        let player = WSPlayer(playerId: playerId)
        
        let game = WSGame(hostPlayer: player, boardSize: boardSize, delegate: delegate)
        games[game.gameId] = game
        
        return game
    }
    
    private func joinGame(gameId: String, playerId: String) {
        let player = WSPlayer(playerId: playerId)
        guard let game = games[gameId] else {
            return
        }
        
        game.joinGame(player: player)
    }
}
