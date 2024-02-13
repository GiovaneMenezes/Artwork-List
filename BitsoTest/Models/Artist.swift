import ArtistsAPI

struct Artist {
    let id: Int
    let title: String
    let birthDate: Int?
    let deathDate: Int?
    let isArtist: Bool
    let description: String?
}

extension Artist {
    init(artist: InboundArtist) {
        self.id = artist.id
        self.title = artist.title
        self.birthDate = artist.birthDate
        self.deathDate = artist.deathDate
        self.isArtist = artist.isArtist
        self.description = artist.description
    }
}
