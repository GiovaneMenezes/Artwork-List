@testable import ArtistsAPI
@testable import TestsSupport
@testable import BitsoNetworking
import XCTest

class ArtistsAPITests: XCTestCase {
    func test_getArtist_successfulResponse() async throws {
        let fetcher = TestFetcher(fetchResponse: .success(response))
        let sut = ArtistsAPI(fetcher: fetcher)
        let artist = try await sut.getArtist(id: 123)
        
        XCTAssertEqual(artist.id, self.artist.id)
    }
    
    func test_getArtist_failureResponse() async {
        let response = ErrorExample.example1
        let fetcher = TestFetcher(fetchResponse: .failure(response))
        let sut = ArtistsAPI(fetcher: fetcher)
        
        do {
            _ = try await sut.getArtist(id: 123)
            XCTFail("response is not expected")
        } catch {
            XCTAssertEqual(error.localizedDescription, response.localizedDescription)
        }
    }
}

extension ArtistsAPITests {
    var artist: InboundArtist {
        InboundArtist(
            id: 123,
            title: "Title",
            birthDate: 1900,
            deathDate: 1950,
            isArtist: true,
            description: "")
    }
    
    var response: DefaultResponse<InboundArtist> {
        DefaultResponse(data: artist)
    }
}
