import ArtistsAPI

protocol IArtistsRepository {
    func getArtist(id: Int) async throws -> Artist
}

struct ArtistsRepository: IArtistsRepository {
    
    private let artistsAPI: IArtistsAPI
    
    init(artistsAPI: IArtistsAPI = ArtistsAPI()) {
        self.artistsAPI = artistsAPI
    }
    
    func getArtist(id: Int) async throws -> Artist {
        Artist(artist: try await artistsAPI.getArtist(id: id))
    }
}
