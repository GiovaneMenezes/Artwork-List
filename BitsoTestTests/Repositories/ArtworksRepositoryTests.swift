import XCTest
@testable import ArtworksAPI
@testable import BitsoNetworking
@testable import BitsoTest

class ArtworksRepositoryTests: XCTestCase {
    
    func test_getArtworksPage_failureResponse_notFirstPage() async {
        let response = ErrorExample.example1
        let artworksAPI = IArtworksAPISpy(fetchArtworksPageResponse: .failure(response))
        let artistLocalDataSource = IArtworksLocalDataSourceSpy()
        let sut = ArtworksRepository(artworksAPI: artworksAPI, artistLocalDataSource: artistLocalDataSource)
        
        artistLocalDataSource.fetchArtWorksResponse = .success([artwork])
        
        do {
            _ = try await sut.getArtworksPage(page: 2)
            XCTFail("Response not expected")
        } catch {
            XCTAssertEqual(error as? ErrorExample, response)
        }
    }
    
    func test_getArtworksPage_failureResponse_noPageStored() async {
        let response = ErrorExample.example1
        let artworksAPI = IArtworksAPISpy(fetchArtworksPageResponse: .failure(response))
        let artistLocalDataSource = IArtworksLocalDataSourceSpy()
        let sut = ArtworksRepository(artworksAPI: artworksAPI, artistLocalDataSource: artistLocalDataSource)
        
        artistLocalDataSource.fetchArtWorksResponse = .failure(response)
        
        do {
            _ = try await sut.getArtworksPage(page: 1)
            XCTFail("Response not expected")
        } catch {
            XCTAssertEqual(error as? ErrorExample, response)
        }
    }
    
    func test_getArtworksPage_failureResponse_pageStored() async throws {
        let response = ErrorExample.example1
        let artworksAPI = IArtworksAPISpy(fetchArtworksPageResponse: .failure(response))
        let artistLocalDataSource = IArtworksLocalDataSourceSpy()
        let sut = ArtworksRepository(artworksAPI: artworksAPI, artistLocalDataSource: artistLocalDataSource)
        
        artistLocalDataSource.fetchArtWorksResponse = .success([artwork])
        
        let artworksPage = try await sut.getArtworksPage(page: 1)
        
        XCTAssertEqual(artworksPage.pagination.currentPage, 1)
        XCTAssertEqual(artworksPage.pagination.totalPages, 1)
        XCTAssertEqual(artworksPage.data.count, 1)
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
        let artistLocalDataSource = IArtworksLocalDataSourceSpy()
        let sut = ArtworksRepository(artworksAPI: artworksAPI, artistLocalDataSource: artistLocalDataSource)
        
        let artworksPage = try await sut.getArtworksPage(page: 1)
        
        XCTAssertEqual(artworksPage.pagination.currentPage, response.pagination.currentPage)
        XCTAssertEqual(artworksPage.pagination.totalPages, response.pagination.totalPages)
        XCTAssertEqual(artworksPage.data.count, 1)
    }
    
    func test_getArtworksPage_fetchMultiplePages() async throws {
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
        let artistLocalDataSource = IArtworksLocalDataSourceSpy()
        let sut = ArtworksRepository(artworksAPI: artworksAPI, artistLocalDataSource: artistLocalDataSource)
        
        XCTAssertFalse(artistLocalDataSource.fetchArtWorksWasCalled)
        XCTAssertFalse(artistLocalDataSource.storeArtWorksWasCalled)
        
        _ = try await sut.getArtworksPage(page: 1)
        
        XCTAssertFalse(artistLocalDataSource.fetchArtWorksWasCalled)
        XCTAssertTrue(artistLocalDataSource.storeArtWorksWasCalled)
        
        artistLocalDataSource.reset()
        
        XCTAssertFalse(artistLocalDataSource.fetchArtWorksWasCalled)
        XCTAssertFalse(artistLocalDataSource.storeArtWorksWasCalled)
        
        _ = try await sut.getArtworksPage(page: 2)
        
        XCTAssertFalse(artistLocalDataSource.fetchArtWorksWasCalled)
        XCTAssertFalse(artistLocalDataSource.storeArtWorksWasCalled)
    }
}

extension ArtworksRepositoryTests {
    var artwork: Artwork {
        Artwork(id: 123,
                imageID: "aaaa-aaa",
                title: "Monalisa",
                placeOfOrigin: "Italy",
                dateDisplay: "1500",
                artistIDs: [1],
                artistTitles: ["Davinci"],
                materialTitles: ["Tint", "Canvas"])
    }
}
