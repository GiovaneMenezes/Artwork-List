import Foundation

@MainActor class DetailsViewModel: ObservableObject {
    private let artistsRepository: IArtistsRepository
    private let artWork: Artwork
    private var artists = [Artist]()
    @Published private(set) var isLoading: Bool = true
    @Published private(set) var errorMessage: String?
    
    init(artwork: Artwork, artistsRepository: IArtistsRepository = ArtistsRepository()) {
        self.artistsRepository = artistsRepository
        self.artWork = artwork
    }
    
    func fetchArtistInformation() async {
        isLoading = true
        
        do {
            artists = try await withThrowingTaskGroup(of: Artist.self) { group in
                artWork.artistIDs.forEach { id in
                    group.addTask {
                        try await self.artistsRepository.getArtist(id: id)
                    }
                }
                
                var artists = [Artist]()
                
                for try await artist in group {
                    artists.append(artist)
                }
                
                return artists
            }
        } catch {
            setErrorMessage(error)
        }
        
        isLoading = false
    }
    
    private func setErrorMessage(_ error: Error) {
        errorMessage = "Sorry, the author's information could not be loaded."
    }
    
    private func getImageURL() -> URL? {
        guard let imageID = artWork.imageID else { return nil }
        return URL(string: "https://www.artic.edu/iiif/2/\(imageID)/full/843,/0/default.jpg")
    }
    
    func getArtistsInfo() -> [DetailsArtistInfoModel] {
        artists.map {
            DetailsArtistInfoModel(
                id: $0.id,
                title: $0.title.capitalized,
                period: PeriodFormatter.period(start: $0.birthDate, end: $0.deathDate),
                description: $0.description)
        }
    }
    
    func getArtworkInfo() -> DetailsArtworkInfoModel {
        return DetailsArtworkInfoModel(
            id: artWork.id,
            imageURL: getImageURL(),
            title: artWork.title,
            placeOfOrigin: artWork.placeOfOrigin?.capitalized,
            dateDisplay: artWork.dateDisplay?.capitalized,
            materialTitles: artWork.materialTitles.map { $0.capitalized })
    }
}
