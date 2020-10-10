import Foundation

enum WSBoardCell: Equatable {
    case vacant
    case occupied(playerId: String)
}

enum WSBoardDirection: Int {
    case up = 1
    case upRight = 2
    case right = 3
    case downRight = 4
    case down = 5
    case downLeft = 6
    case left = 7
    case upLeft = 8
}

protocol WSBoardDelegate: AnyObject {
    func boardDidChangeState(_ board: WSBoard?)
    func board(_ board: WSBoard?, didCollideWithPlayerId: String)
}

class WSBoard {
    
    weak var delegate: WSBoardDelegate?
    private let boardSize: Int
    
    let id = UUID().uuidString
    private var grid: [WSBoardCell]
    
    var players = [String: WSPlayer]()
    var playerIds = [String]()
    
    private(set) var hasStarted: Bool = false
    
    init?(boardSize: Int, delegate: WSBoardDelegate? = nil) {
        guard boardSize > 4, boardSize % 2 == 1 else {
            return nil
        }
        
        self.delegate = delegate
        self.boardSize = boardSize
        self.grid = Array.init(repeating: WSBoardCell.vacant, count: boardSize * boardSize)
    }
    
    func add(_ player: WSPlayer) {
        guard players[player.playerId] == nil, players.count < 5 else { return }
        
        players[player.playerId] = player
        playerIds.append(player.playerId)
        let playerInitialIndex = initialBoardPosition(forPlayerNumber: players.count)
        grid[playerInitialIndex] = .occupied(playerId: player.playerId)
        
        delegate?.boardDidChangeState(self)
    }
    
    func start() {
        guard players.count > 1, hasStarted == false else {
            return
        }
        
        hasStarted = true
    }
    
    func move(playerId: String, direction: WSBoardDirection) {
        guard let currentIndex = grid.firstIndex(where: {$0 == .occupied(playerId: playerId)}) else {
            return
        }
        
        var proposedIndex: Int? = nil
        switch direction {
        case .up:
            guard currentIndex >= boardSize else { break }
            proposedIndex = currentIndex - boardSize
        case .upRight:
            guard currentIndex >= boardSize,
                  currentIndex % boardSize != boardSize - 1 else { break }
            proposedIndex = currentIndex - boardSize + 1
        case .right:
            guard currentIndex % boardSize != boardSize - 1 else { break }
            proposedIndex = currentIndex + 1
        case .downRight:
            guard currentIndex <= grid.count - boardSize,
                  currentIndex % boardSize != boardSize - 1 else { break }
            proposedIndex = currentIndex + boardSize + 1
        case .down:
            guard currentIndex <= grid.count - boardSize else { break }
            proposedIndex = currentIndex + boardSize
        case .downLeft:
            guard currentIndex <= grid.count - boardSize,
                  currentIndex % boardSize != 0 else { break }
            proposedIndex = currentIndex + boardSize - 1
        case .left:
            guard currentIndex % boardSize != 0 else { break }
            proposedIndex = currentIndex - 1
        case .upLeft:
            guard currentIndex >= boardSize,
                  currentIndex % boardSize != 0 else { break }
            proposedIndex = currentIndex - boardSize - 1
        }
        
        guard let checkIndex = proposedIndex else {
            return
        }
        
        guard checkIndex < grid.count, checkIndex >= 0 else {
            return
        }
        
        switch grid[checkIndex] {
        case .vacant:
            grid[checkIndex] = .occupied(playerId: playerId)
            grid[currentIndex] = .vacant
        case .occupied(let otherPlayerId):
            print("\(playerId) Collision with \(otherPlayerId)")
            #warning("TODO: notify of capture")
            break
        }
        
        delegate?.boardDidChangeState(self)
    }
    
    func boardNotation() -> String {
        var notation = ""
        for cell in grid {
            switch cell {
            case .vacant:
                notation.append("0,")
            case .occupied(let playerId):
                notation.append("\(playerId),")
            }
        }
        notation = notation.trimmingCharacters(in: CharacterSet([","]))
        return notation
    }
}

private extension WSBoard {
    func initialBoardPosition(forPlayerNumber number: Int) -> Int {
        let index: Int
        switch number {
        case 1:
            index = (grid.count / 2)
        case 2:
            index = 0
        case 3:
            index = grid.count - 1
        case 4:
            index = Int( sqrt(Double(grid.count)) ) - 1
        case 5:
            index = grid.count - Int( sqrt(Double(grid.count)) )
        default:
            fatalError("No more than 5 players")
        }
        
        return index
    }
}
