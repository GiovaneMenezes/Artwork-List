import BitsoNetworking

public protocol IArtistsAPI {
    func getArtist(id: Int) async throws -> InboundArtist
}

public struct ArtistsAPI: IArtistsAPI {
    let fetcher: IFetcher
    
    public init(fetcher: IFetcher = Fetcher()) {
        self.fetcher = fetcher
    }
    
    public func getArtist(id: Int) async throws -> InboundArtist {
        try await fetcher.fetch(endpoint: ArtistsEndpoint.getAuthor(id: id), type: InboundArtist.self)
    }
}
