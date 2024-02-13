import ArtworksAPI
import BitsoNetworking
import Foundation

class IArtworksAPISpy: IArtworksAPI {
    
    var fetchArtworksPageWasCalled = false
    var fetchArtworksPageResponse: Result<BitsoNetworking.Page<InboundArtwork>, Error>
    
    init(fetchArtworksPageResponse: Result<Page<InboundArtwork>, Error>) {
        self.fetchArtworksPageResponse = fetchArtworksPageResponse
    }
    
    func fetchArtworksPage(page: Int) async throws -> BitsoNetworking.Page<InboundArtwork> {
        fetchArtworksPageWasCalled = true
        switch fetchArtworksPageResponse {
        case let .success(response):
            return response
        case let .failure(error):
            throw error
        }
    }
}
