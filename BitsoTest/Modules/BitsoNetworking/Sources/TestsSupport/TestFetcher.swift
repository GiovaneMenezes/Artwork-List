import BitsoNetworking

public class TestFetcher: IFetcher {
    
    var fetchResponse: Result<Decodable, Error>
    
    public init(fetchResponse: Result<Decodable, Error>) {
        self.fetchResponse = fetchResponse
    }
    
    public func fetch<T: Decodable>(endpoint: BitsoNetworking.Endpoint, type: T.Type) async throws -> T {
        switch fetchResponse {
        case .success(let success):
            return success as! T
        case .failure(let failure):
            throw failure
        }
    }
}
