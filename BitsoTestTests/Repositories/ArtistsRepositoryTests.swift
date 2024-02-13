import XCTest
@testable import ArtistsAPI
@testable import BitsoNetworking
@testable import BitsoTest

class ArtistsRepositoryTests: XCTestCase {
    
    func test_getArtists_failureResponse() async {
        let response = ErrorExample.example1
        let artistsAPI = IArtistsAPISpy(getArtistsPageResponse: .failure(response))
        let sut = ArtistsRepository(artistsAPI: artistsAPI)
        
        do {
            _ = try await sut.getArtist(id: 123)
            XCTFail("Response not expected")
        } catch {
            XCTAssertEqual(error as? ErrorExample, response)
        }
        
        XCTAssert(artistsAPI.getArtistsPageWasCalled)
    }
    
    func test_getArtists_successfulResponse() async throws {
        let response = InboundArtist(
            id: 321,
            title: "Title",
            birthDate: nil,
            deathDate: nil,
            isArtist: true,
            description: nil)
        let artistsAPI = IArtistsAPISpy(getArtistsPageResponse: .success(response))
        let sut = ArtistsRepository(artistsAPI: artistsAPI)
        
        let artist = try await sut.getArtist(id: 321)
        
        XCTAssertEqual(response.id, artist.id)
        
        XCTAssert(artistsAPI.getArtistsPageWasCalled)
    }
}
