import ArtworksAPI

protocol IArtworksRepository {
    func getArtworksPage(page: Int) async throws -> Page<Artwork>
}

struct ArtworksRepository: IArtworksRepository {
    
    private let artworksAPI: IArtworksAPI
    private let artistLocalDataSource: IArtworksLocalDataSource
    
    init(
        artworksAPI: IArtworksAPI = ArtworksAPI(),
        artistLocalDataSource: IArtworksLocalDataSource = ArtworksLocalDataSource()
    ) {
        self.artworksAPI = artworksAPI
        self.artistLocalDataSource = artistLocalDataSource
    }
    
    func getArtworksPage(page: Int) async throws -> Page<Artwork> {
        do {
            let response = try await artworksAPI.fetchArtworksPage(page: page)
            let parsedPage = Page(pagination: Pagination(pagination: response.pagination), data: response.data.map { Artwork(artwork: $0) })
            if page == 1 {
                try? artistLocalDataSource.storeArtWorks(parsedPage.data)
            }
            return parsedPage
        } catch {
            if page == 1 {
                guard let localArtworks = try? artistLocalDataSource.fetchArtWorks() else { throw error }
                return Page(pagination: Pagination(currentPage: 1, totalPages: 1), data: localArtworks )
            } else {
                throw error
            }
        }
    }
}
