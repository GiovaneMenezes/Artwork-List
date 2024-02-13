import ArtistsAPI
import BitsoNetworking
import Foundation

class IArtistsAPISpy: IArtistsAPI {
    
    var getArtistsPageWasCalled = false
    var getArtistsPageResponse: Result<InboundArtist, Error>
    
    init(getArtistsPageResponse: Result<InboundArtist, Error>) {
        self.getArtistsPageResponse = getArtistsPageResponse
    }
    
    func getArtist(id: Int) async throws -> InboundArtist {
        
        getArtistsPageWasCalled = true
        
        switch getArtistsPageResponse {
        case let .success(artist):
            return artist
        case let .failure(error):
            throw error
        }
    }
}
