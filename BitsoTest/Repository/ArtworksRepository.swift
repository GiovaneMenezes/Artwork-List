import ArtworksAPI
import Foundation

enum ArtworksRepositoryError {
    case noMorePagesAvailable
}

protocol IArtworksRepository {
    var nextPageAvailable: Bool { get }
    func resetPagination()
    func getNextPage() async throws -> [Artwork]
}

extension ArtworksRepositoryError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noMorePagesAvailable:
            return "There's no more pages available."
        }
    }
}

class ArtworksRepository: IArtworksRepository {
    
    init(artworksAPI: IArtworksAPI = ArtworksAPI(), currentPage: Int = 1) {
        self.artworksAPI = artworksAPI
        self.currentPage = currentPage
    }
    
    let artworksAPI: IArtworksAPI
    private var currentPage = 1
    private var totalPages: Int?
    private var loadingNextPage = false
    
    var nextPageAvailable: Bool {
        guard let totalPages else { return true }
        return totalPages >= currentPage
    }
    
    func resetPagination() {
        currentPage = 1
        totalPages = nil
        loadingNextPage = false
    }
    
    func getNextPage() async throws -> [Artwork] {
        guard !loadingNextPage else { return [] }
        loadingNextPage = true
        if nextPageAvailable {
            let artworks = try await artworksAPI.fetchArtworksPage(page: currentPage)
            currentPage += 1
            totalPages = artworks.pagination.totalPages
            loadingNextPage = false
            return artworks.data.map { Artwork(artwork: $0) }
        } else {
            loadingNextPage = false
            throw ArtworksRepositoryError.noMorePagesAvailable
        }
    }
}
