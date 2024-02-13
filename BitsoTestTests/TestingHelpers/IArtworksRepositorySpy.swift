@testable import BitsoTest

class IArtworksRepositorySpy: IArtworksRepository {
    
    private(set) var getArtworksPageWasCalled = false
    var getArtworksPageResponse: Result<Page<Artwork>, Error>
    
    init(getArtworksPageResponse: Result<Page<Artwork>, Error>) {
        self.getArtworksPageResponse = getArtworksPageResponse
    }
    
    func reset() {
        getArtworksPageWasCalled = false
    }
    
    func getArtworksPage(page: Int) async throws -> Page<Artwork> {
        getArtworksPageWasCalled = true
        switch getArtworksPageResponse {
        case .success(let success):
            return success
        case .failure(let failure):
            throw failure
        }
    }
}
