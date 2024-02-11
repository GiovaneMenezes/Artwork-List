import Foundation

public struct InboundArtwork: Decodable {
    public let id: Int
    public let imageID: String
    public let title: String?
    public let placeOfOrigin: String?
    public let dateDisplay: String?
    public let artistIDs: [Int]
    public let artistTitles: [String]
    public let materialTitles: [String]
    
    enum CodingKeys: String, CodingKey {
        case id
        case imageID = "image_id"
        case title
        case placeOfOrigin = "place_of_origin"
        case dateDisplay = "date_display"
        case artistIDs = "artist_ids"
        case artistTitles = "artist_titles"
        case materialTitles = "material_titles"
    }
}
