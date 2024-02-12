import Foundation

class DetailsViewModel {
    private let artistsRepository: IArtistsRepository
    
    init(artwork: Artwork, artistsRepository: IArtistsRepository = ArtistsRepository()) {
        self.artistsRepository = artistsRepository
    }
}
