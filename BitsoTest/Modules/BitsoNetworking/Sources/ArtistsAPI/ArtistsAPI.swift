import BitsoNetworking

public protocol IArtistsAPI {
    func getArtist(id: Int) async throws -> InboundAuthor
}

public struct ArtistsAPI: IArtistsAPI {
    let fetcher: IFetcher
    
    public init(fetcher: IFetcher = Fetcher()) {
        self.fetcher = fetcher
    }
    
    public func getArtist(id: Int) async throws -> InboundAuthor {
        try await fetcher.fetch(endpoint: ArtistsEndpoint.getAuthor(id: id), type: InboundAuthor.self)
    }
}
