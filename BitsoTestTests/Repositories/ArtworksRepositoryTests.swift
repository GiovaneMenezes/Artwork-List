import XCTest
@testable import ArtworksAPI
@testable import BitsoNetworking
@testable import BitsoTest

class ArtworksRepositoryTests: XCTestCase {
    
    func test_getArtworksPage_failureResponse() async {
        let response = ErrorExample.example1
        let artworksAPI = IArtworksAPISpy(fetchArtworksPageResponse: .failure(response))
        let sut = ArtworksRepository(artworksAPI: artworksAPI)
        
        do {
            _ = try await sut.getArtworksPage(page: 1)
            XCTFail("Response not expected")
        } catch {
            XCTAssertEqual(error as? ErrorExample, response)
        }
    }
    
    func test_getArtworksPage_successfulResponse() async throws {
        let response = BitsoNetworking.Page<InboundArtwork>(
            pagination: Pagination(currentPage: 1, totalPages: 100),
            data: [
                InboundArtwork(
                    id: 123,
                    imageID: nil,
                    title: "Title",
                    placeOfOrigin: "Origin",
                    dateDisplay: "1993 - Now",
                    artistIDs: [123],
                    artistTitles: ["John Doe"],
                    materialTitles: ["Wood", "Tint"])
            ])
        let artworksAPI = IArtworksAPISpy(fetchArtworksPageResponse: .success(response))
        let sut = ArtworksRepository(artworksAPI: artworksAPI)
        
        let artworksPage = try await sut.getArtworksPage(page: 1)
        
        XCTAssertEqual(artworksPage.pagination.currentPage, response.pagination.currentPage)
        XCTAssertEqual(artworksPage.pagination.totalPages, response.pagination.totalPages)
        XCTAssertEqual(artworksPage.data.count, 1)
    }
}
