import Foundation

public enum WSMessageType: String, Codable {
    case info = "in"
    case gameUpdate = "gu"
    case availableGameIdsRequest = "ag"
    case currentGameId = "cgi"
}

public struct WSMessage: Codable {
    public let type: WSMessageType
    public var message: String?
    public var messageCollection: [String]?
    
    public init(type: WSMessageType, message: String? = nil, messageCollection: [String]? = nil) {
        self.type = type
        self.message = message
        self.messageCollection = messageCollection
    }
    
    enum CodingKeys: String, CodingKey {
        case type = "t"
        case message = "m"
    }
}
