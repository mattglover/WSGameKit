import Foundation

public enum WSCommandType: String, Codable {
    case info = "in"
    case setup = "su"
    case start = "st"
    case move = "mv"
}

public struct WSCommand: Codable {
    
    let type: WSCommandType
    let playerId: String
    let gameId: String?
    let command: String
    
    enum CodingKeys: String, CodingKey {
        case type = "t"
        case playerId = "p"
        case gameId = "g"
        case command = "c"
    }
}
