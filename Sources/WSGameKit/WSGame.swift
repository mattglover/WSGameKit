import Foundation

public protocol WSGameDelegate: AnyObject {
    func gameDidUpdate(_ game: WSGame)
}

public class WSGame {
    
    public let gameId = UUID().uuidString
    public weak var delegate: WSGameDelegate?
    let gameBoard: WSBoard!
    var hostPlayer: WSPlayer?
    var guestPlayers: [WSPlayer] = []
    
    var isOrphenedGame: Bool {
        return hostPlayer == nil && guestPlayers.count == 0
    }
    
    var canStart: Bool {
        return gameBoard.hasStarted == false && hostPlayer != nil && guestPlayers.count > 0
    }
    
    public var gameState: String {
        return gameBoard.boardNotation()
    }
    
    public var playerIds: [String] {
    
        var playerIds = [hostPlayer?.playerId]
        let guestPlayerIds = guestPlayers.map( {$0.playerId} )
        playerIds.append(contentsOf: guestPlayerIds)
        
        return playerIds.compactMap({$0})
    }
    
    required init(hostPlayer: WSPlayer, boardSize: Int? = nil, delegate: WSGameDelegate? = nil, gameBoard: WSBoard? = nil) {
        
        if let gameBoard = gameBoard {
            self.gameBoard = gameBoard
        } else {
            guard let boardSize = boardSize, let gameBoard = WSBoard(boardSize: boardSize) else {
                fatalError("Unable to create Game")
            }
            self.gameBoard = gameBoard
        }
        
        self.delegate = delegate
        self.gameBoard.delegate = self
        
        self.hostPlayer = hostPlayer
        self.gameBoard.add(hostPlayer)
        hostPlayer.currentGame = self
    }
    
    func joinGame(player: WSPlayer) {
        guard let hostPlayer = hostPlayer,
              hostPlayer.playerId != player.playerId,
              guestPlayers.filter({$0.playerId == player.playerId}).count == 0 else {
            return
        }
        gameBoard.add(player)
        guestPlayers.append(player)
    }
    
    func leaveGame(player: WSPlayer) {
        guard let hostPlayer = hostPlayer,
              hostPlayer.playerId != player.playerId else {
            
            player.currentGame = nil
            self.hostPlayer = nil
            
            promoteFirstGuestToHost()
            
            return
        }
        
        guestPlayers.removeAll(where: { $0.playerId == player.playerId })
        player.currentGame = nil
    }
    
    func startGame() {
        if canStart {
            gameBoard.start()
        }
    }
    
    func handleCommand(command: String, playerId: String) {
        switch command {
        case "up":
            gameBoard.move(playerId: playerId, direction: .up)
        case "down":
            gameBoard.move(playerId: playerId, direction: .down)
        case "left":
            gameBoard.move(playerId: playerId, direction: .left)
        case "right":
            gameBoard.move(playerId: playerId, direction: .right)
        case "upRight":
            gameBoard.move(playerId: playerId, direction: .upRight)
        case "upLeft":
            gameBoard.move(playerId: playerId, direction: .upLeft)
        case "downRight":
            gameBoard.move(playerId: playerId, direction: .downRight)
        case "downLeft":
            gameBoard.move(playerId: playerId, direction: .downLeft)
        default:
            break
        }
    }
}

extension WSGame: WSBoardDelegate {
    func boardDidChangeState(_ board: WSBoard?) {
        delegate?.gameDidUpdate(self)
    }
    
    func board(_ board: WSBoard?, didCollideWithPlayerId: String) {
        delegate?.gameDidUpdate(self)
    }
}

// MARK: - Utilities
private extension WSGame {
    func promoteFirstGuestToHost() {
        guard let firstGuestPlayer = guestPlayers.first else {
            return
        }
        
        hostPlayer = firstGuestPlayer
        guestPlayers.removeAll(where: { $0.playerId == firstGuestPlayer.playerId })
    }
}
