import BitsoDataPersistency

protocol IArtworksLocalDataSource {
    func storeArtWorks(_ artWorks: [Artwork]) throws
    func fetchArtWorks() throws -> [Artwork]
}

struct ArtworksLocalDataSource: IArtworksLocalDataSource {
    
    private var dataPersistencyService: IDataPersistencyService
    
    init(dataPersistencyService: IDataPersistencyService = DataPersistencyService()) {
        self.dataPersistencyService = dataPersistencyService
    }
    
    func storeArtWorks(_ artWorks: [Artwork]) throws {
        try dataPersistencyService.storeData(artWorks)
    }
    
    func fetchArtWorks() throws -> [Artwork] {
        try dataPersistencyService.fetchData([Artwork].self)
    }
}
