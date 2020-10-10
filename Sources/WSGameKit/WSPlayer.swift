import Foundation

class WSPlayer {
    private(set) var playerId = UUID().uuidString
    weak var currentGame: WSGame?
    
    init(playerId: String = UUID().uuidString) {
        self.playerId = playerId
    }
}
