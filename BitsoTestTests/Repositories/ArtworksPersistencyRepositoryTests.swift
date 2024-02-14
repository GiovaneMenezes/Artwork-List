import XCTest
@testable import BitsoTest

class ArtworksPersistencyRepositoryTests: XCTestCase {
    func test_fetchData_successfulResponse() throws {
        let dataPersistencyService = IDataPersistencyServiceSpy()
        let sut = ArtworksPersistencyRepository(dataPersistencyService: dataPersistencyService)
        
        dataPersistencyService.fetchArtWorksResponse = .success([Artwork]())
        
        _ = try sut.fetchArtWorks()
        
        XCTAssertTrue(dataPersistencyService.fetchDataWasCalled)
    }
    
    func test_fetchData_failureResponse() {
        let response = ErrorExample.example1
        let dataPersistencyService = IDataPersistencyServiceSpy()
        let sut = ArtworksPersistencyRepository(dataPersistencyService: dataPersistencyService)
        
        dataPersistencyService.fetchArtWorksResponse = .failure(response)
        
        do {
            _ = try sut.fetchArtWorks()
            XCTFail("Response is not expected.")
        } catch {
            XCTAssertEqual(error.localizedDescription, response.localizedDescription)
        }
        
        XCTAssertTrue(dataPersistencyService.fetchDataWasCalled)
    }
    
    func test_storeData() throws {
        let dataPersistencyService = IDataPersistencyServiceSpy()
        let sut = ArtworksPersistencyRepository(dataPersistencyService: dataPersistencyService)
        
        try sut.storeArtWorks([])
        
        XCTAssertTrue(dataPersistencyService.storeDataWasCalled)
    }
}
