import Foundation

public protocol IFetcher {
    func fetch<T: Decodable>(endpoint: Endpoint, type: T.Type) async throws -> T
}

public struct Fetcher: IFetcher {
    public func fetch<T: Decodable>(endpoint: Endpoint, type: T.Type) async throws -> T {
        let (data, _) = try await URLSession.shared.data(for: endpoint.urlRequest())
        return try JSONDecoder().decode(T.self, from: data)
    }
}
