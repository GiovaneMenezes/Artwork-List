import ArtworksAPI

protocol IArtworksRepository {
    func getArtworksPage(page: Int) async throws -> Page<Artwork>
}

struct ArtworksRepository: IArtworksRepository {
    
    private let artworksAPI: IArtworksAPI
    
    init(artworksAPI: IArtworksAPI = ArtworksAPI()) {
        self.artworksAPI = artworksAPI
    }
    
    func getArtworksPage(page: Int) async throws -> Page<Artwork> {
        let response = try await artworksAPI.fetchArtworksPage(page: page)
        return Page(pagination: Pagination(pagination: response.pagination), data: response.data.map { Artwork(artwork: $0) })
    }
}
