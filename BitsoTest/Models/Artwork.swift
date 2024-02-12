import ArtworksAPI

struct Artwork {
    let id: Int
    let imageID: String?
    let title: String?
    let placeOfOrigin: String?
    let dateDisplay: String?
    let artistIDs: [Int]
    let artistTitles: [String]
    let materialTitles: [String]
}

extension Artwork {
    init(artwork: InboundArtwork) {
        id = artwork.id
        imageID = artwork.imageID
        title = artwork.title
        placeOfOrigin = artwork.placeOfOrigin
        dateDisplay = artwork.dateDisplay
        artistIDs = artwork.artistIDs
        artistTitles = artwork.artistTitles
        materialTitles = artwork.materialTitles
    }
}
