import Foundation

public struct InboundArtist: Decodable {
    public let id: Int
    public let birthDate: Int?
    public let deathDate: Int?
    public let isArtist: Bool
    public let description: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case birthDate = "birth_date"
        case deathDate = "death_date"
        case isArtist = "is_artist"
        case description
    }
}
