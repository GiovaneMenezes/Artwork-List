@testable import BitsoTest

class IArtistsRepositorySpy: IArtistsRepository {
    private(set) var getArtistWasCalled = false
    var getArtistResponse: Result<BitsoTest.Artist, Error>
    
    init(getArtistResponse: Result<Artist, Error>) {
        self.getArtistResponse = getArtistResponse
    }
    
    func getArtist(id: Int) async throws -> BitsoTest.Artist {
        getArtistWasCalled = true
        switch getArtistResponse {
        case .success(let success):
            return success
        case .failure(let failure):
            throw failure
        }
    }
}
