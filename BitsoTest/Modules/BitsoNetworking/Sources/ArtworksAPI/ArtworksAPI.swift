import BitsoNetworking

public protocol IArtworksAPI {
    func fetchArtworksPage(page: Int) async throws -> Page<InboundArtwork>
}

public struct ArtworksAPI: IArtworksAPI {
    let fetcher: IFetcher
    
    public init(fetcher: IFetcher = Fetcher()) {
        self.fetcher = fetcher
    }
    
    public func fetchArtworksPage(page: Int) async throws -> Page<InboundArtwork> {
        try await fetcher.fetch(endpoint: ArtworksEndpoint.getPage(page: page), type: Page<InboundArtwork>.self)
    }
}
