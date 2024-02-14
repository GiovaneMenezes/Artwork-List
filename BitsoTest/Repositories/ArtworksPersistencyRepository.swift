import BitsoDataPersistency

protocol IArtworksPersistencyRepository {
    func storeArtWorks(_ artWorks: [Artwork]) throws
    func fetchArtWorks() throws -> [Artwork]
}

struct ArtworksPersistencyRepository: IArtworksPersistencyRepository {
    
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
