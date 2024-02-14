@testable import BitsoTest

class IArtworksLocalDataSourceSpy: IArtworksLocalDataSource {
    private(set) var storeArtWorksWasCalled = false
    private(set) var fetchArtWorksWasCalled = false
    
    var fetchArtWorksResponse: Result<[Artwork], Error> = .success([])
    
    func storeArtWorks(_ artWorks: [Artwork]) throws {
        storeArtWorksWasCalled = true
    }
    
    func fetchArtWorks() throws -> [Artwork] {
        fetchArtWorksWasCalled = true
        switch fetchArtWorksResponse {
        case .success(let success):
            return success
        case .failure(let failure):
            throw failure
        }
    }
    
    func reset() {
        storeArtWorksWasCalled = false
        fetchArtWorksWasCalled = false
    }
}
