import Foundation

class ListViewModel {
    
    @Published var hasInternetConnection: Bool = true
    @Published var arts: [Artwork] = [Artwork]()
    @Published var errorMessage: String?
    
    var oldArtsQuantity: Int?
    
    var nextPageAvailable: Bool {
        get async {
            await artworksRepository.nextPageAvailable
        }
    }
    
    private let artworksRepository: IArtworksRepository
    
    init(artworksRepository: IArtworksRepository) {
        self.artworksRepository = artworksRepository
    }
    
    func fetchNextPage() {
        Task {
            do {
                if await artworksRepository.nextPageAvailable {
                    let artsCount = self.arts.count
                    let nextPage = try await artworksRepository.getNextPage()
                    if nextPage.count > 0 {
                        self.oldArtsQuantity = artsCount + nextPage.count
                        self.arts.append(contentsOf: nextPage)
                    }
                }
            } catch {
                self.presentError(error)
            }
        }
    }
    
    func refreshList() {
        arts = []
        Task {
            await artworksRepository.resetPagination()
            self.fetchNextPage()
        }
    }
    
    private func presentError(_ error: Error) {
        if let error = error as? ArtworksRepositoryError, error == .noMorePagesAvailable {
            return
        }
        errorMessage = error.localizedDescription
    }
    
    func title(for indexPath: IndexPath) -> String {
        guard arts.indices.contains(indexPath.row) else { return "" }
        return arts[indexPath.row].title ?? ""
    }
    
    func subtitle(for indexPath: IndexPath) -> String {
        guard arts.indices.contains(indexPath.row) else { return "" }
        return [
            arts[indexPath.row].artistTitles.count > 0 ? arts[indexPath.row].artistTitles.joined(separator: ", ") : nil,
            arts[indexPath.row].dateDisplay
        ].compactMap { $0 }.joined(separator: " - ")
    }
}
