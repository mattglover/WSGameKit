import Foundation

public enum WSCommandType: String, Codable {
    case info = "in"
    case setup = "su"
    case start = "st"
    case move = "mv"
}

public struct WSCommand: Codable {
    
    public let type: WSCommandType
    public let playerId: String
    public let gameId: String?
    public let command: String
    
    public enum CodingKeys: String, CodingKey {
        case type = "t"
        case playerId = "p"
        case gameId = "g"
        case command = "c"
    }
}
