import XCTest
@testable import BitsoTest

class ListViewModelTests: XCTestCase {
    func test_fetchNextPage_successfulResponse() async throws {
        let artworksRepository = IArtworksRepositorySpy(getArtworksPageResponse: .success(page(currentPage: 1, totalPages: 3)))
        let artworksPersistencyRepository = IArtworksPersistencyRepositorySpy()
        let sut = ListViewModel(artworksRepository: artworksRepository, artworksPersistencyRepository: artworksPersistencyRepository)
        
        await sut.fetchNextPage()
        
        XCTAssertEqual(sut.arts.count, 1)
        XCTAssertEqual(sut.arts.first?.id, artwork.id)
        XCTAssert(artworksRepository.getArtworksPageWasCalled)
        XCTAssertTrue(artworksPersistencyRepository.storeArtWorksWasCalled)
        XCTAssertFalse(artworksPersistencyRepository.fetchArtWorksWasCalled)
        artworksRepository.reset()
        artworksPersistencyRepository.reset()
        
        artworksRepository.getArtworksPageResponse = .success(page(currentPage: 2, totalPages: 3))
        
        await sut.fetchNextPage()
        
        XCTAssertEqual(sut.arts.count, 2)
        XCTAssertEqual(sut.arts.first?.id, artwork.id)
        XCTAssert(artworksRepository.getArtworksPageWasCalled)
        XCTAssertFalse(artworksPersistencyRepository.storeArtWorksWasCalled)
        XCTAssertFalse(artworksPersistencyRepository.fetchArtWorksWasCalled)
        artworksRepository.reset()
        
        artworksRepository.getArtworksPageResponse = .success(page(currentPage: 3, totalPages: 3))
        
        await sut.fetchNextPage()
        
        XCTAssertEqual(sut.arts.count, 3)
        XCTAssertEqual(sut.arts.first?.id, artwork.id)
        XCTAssert(artworksRepository.getArtworksPageWasCalled)
        artworksRepository.reset()
        
        await sut.fetchNextPage()
        
        XCTAssertEqual(sut.arts.count, 3)
        XCTAssertEqual(sut.arts.first?.id, artwork.id)
        XCTAssertFalse(artworksRepository.getArtworksPageWasCalled)
        artworksRepository.reset()
    }
    
    func test_fetchNextPage_failureResponse_firstPageStored() async throws {
        let response = ErrorExample.example1
        let artworksRepository = IArtworksRepositorySpy(getArtworksPageResponse: .failure(response))
        let artworksPersistencyRepository = IArtworksPersistencyRepositorySpy()
        let sut = ListViewModel(artworksRepository: artworksRepository, artworksPersistencyRepository: artworksPersistencyRepository)
        
        artworksPersistencyRepository.fetchArtWorksResponse = .success([artwork, artwork])
        
        await sut.fetchNextPage()
        
        XCTAssertNil(sut.errorMessage)
        XCTAssertEqual(sut.arts.count, 2)
        XCTAssertTrue(artworksPersistencyRepository.fetchArtWorksWasCalled)
    }
    
    func test_fetchNextPage_failureResponse_firstPageNotStored() async throws {
        let response = ErrorExample.example1
        let artworksRepository = IArtworksRepositorySpy(getArtworksPageResponse: .failure(response))
        let artworksPersistencyRepository = IArtworksPersistencyRepositorySpy()
        let sut = ListViewModel(artworksRepository: artworksRepository, artworksPersistencyRepository: artworksPersistencyRepository)
        
        artworksPersistencyRepository.fetchArtWorksResponse = .failure(response)
        
        await sut.fetchNextPage()
        
        XCTAssertEqual(sut.errorMessage, response.localizedDescription)
        XCTAssertEqual(sut.arts.count, 0)
        XCTAssertTrue(artworksPersistencyRepository.fetchArtWorksWasCalled)
    }
    
    func test_refreshList_successfulResponse() async throws {
        let artworksRepository = IArtworksRepositorySpy(getArtworksPageResponse: .success(page(currentPage: 1, totalPages: 3)))
        let sut = ListViewModel(artworksRepository: artworksRepository)
        
        await sut.fetchNextPage()
        
        XCTAssertEqual(sut.arts.count, 1)
        
        artworksRepository.getArtworksPageResponse = .success(page(currentPage: 2, totalPages: 3))
        
        await sut.fetchNextPage()
        
        XCTAssertEqual(sut.arts.count, 2)
        
        artworksRepository.getArtworksPageResponse = .success(page(currentPage: 1, totalPages: 3))
        
        await sut.refreshList()
        
        XCTAssertEqual(sut.arts.count, 1)
        XCTAssertEqual(sut.arts.first?.id, artwork.id)
    }
    
    func test_refreshList_failureResponse() async throws {
        let response = ErrorExample.example1
        let artworksRepository = IArtworksRepositorySpy(getArtworksPageResponse: .success(page(currentPage: 1, totalPages: 3)))
        let artworksPersistencyRepository = IArtworksPersistencyRepositorySpy()
        let sut = ListViewModel(artworksRepository: artworksRepository, artworksPersistencyRepository: artworksPersistencyRepository)
        
        await sut.fetchNextPage()
        
        XCTAssertEqual(sut.arts.count, 1)
        XCTAssertEqual(sut.arts.first?.id, artwork.id)
        
        artworksRepository.getArtworksPageResponse = .success(page(currentPage: 2, totalPages: 3))
        
        await sut.fetchNextPage()
        
        XCTAssertEqual(sut.arts.count, 2)
        
        artworksRepository.getArtworksPageResponse = .failure(response)
        
        await sut.refreshList()
        
        XCTAssertEqual(sut.arts.count, 2)
        XCTAssertFalse(artworksPersistencyRepository.fetchArtWorksWasCalled)
    }
    
    func test_titleAndSubtitle() async throws {
        let artworksRepository = IArtworksRepositorySpy(getArtworksPageResponse: .success(page(currentPage: 1, totalPages: 3)))
        let sut = ListViewModel(artworksRepository: artworksRepository)
        
        await sut.fetchNextPage()
        
        XCTAssertEqual(sut.title(for: .init(row: 0, section: 0)), "Monalisa")
        XCTAssertEqual(sut.subtitle(for: .init(row: 0, section: 0)), "Davinci - 1500")
    }
}

extension ListViewModelTests {
    func page(currentPage: Int, totalPages: Int = 10) -> Page<Artwork> {
        Page<Artwork>(
            pagination: Pagination(currentPage: currentPage,
                                   totalPages: totalPages),
            data: [artwork])
    }
    
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
