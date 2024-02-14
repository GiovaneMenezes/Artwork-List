import BitsoDataPersistency

class IDataPersistencyServiceSpy: IDataPersistencyService {
    
    private(set) var fetchDataWasCalled = false
    private(set) var storeDataWasCalled = false
    
    var fetchArtWorksResponse: Result<Codable, Error> = .success([Int]())
    
    func fetchData<T: Codable>(_ type: T.Type) throws -> T {
        fetchDataWasCalled = true
        switch fetchArtWorksResponse {
        case .success(let success):
            guard let success = success as? T else { throw ErrorExample.example1 }
            return success
        case .failure(let failure):
            throw failure
        }
    }
    
    func storeData<T: Codable>(_ data: T) throws  {
        storeDataWasCalled = true
    }
}
