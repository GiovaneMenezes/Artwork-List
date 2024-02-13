@testable import ArtworksAPI
@testable import TestsSupport
@testable import BitsoNetworking
import XCTest

class ArtworksAPITests: XCTestCase {
    func test_getArtworks_successfulResponse() async throws {
        let fetcher = TestFetcher(fetchResponse: .success(response))
        let sut = ArtworksAPI(fetcher: fetcher)
        let artworkPage = try await sut.fetchArtworksPage(page: 1)
        
        XCTAssertEqual(artworkPage.data.first?.id, artwork.id)
    }
    
    func test_getArtworks_failureResponse() async {
        let response = ErrorExample.example1
        let fetcher = TestFetcher(fetchResponse: .failure(response))
        let sut = ArtworksAPI(fetcher: fetcher)
        
        do {
            _ = try await sut.fetchArtworksPage(page: 1)
            XCTFail("response is not expected")
        } catch {
            XCTAssertEqual(error.localizedDescription, response.localizedDescription)
        }
    }
}

extension ArtworksAPITests {
    var artwork: InboundArtwork {
        InboundArtwork(
            id: 123,
            imageID: "aaa-aaaa-aaa",
            title: "Title",
            placeOfOrigin: nil,
            dateDisplay: nil,
            artistIDs: [1],
            artistTitles: [],
            materialTitles: ["Material"])
    }
    
    var response: Page<InboundArtwork> {
        Page(pagination: Pagination(currentPage: 1, totalPages: 10), data: [artwork])
    }
}
