import Foundation

class ListViewModel {
    @Published var hasInternetConnection: Bool = true
    @Published var arts: [Artwork] = [Artwork]()
    
    var nextPageAvailable: Bool { artworksRepository.nextPageAvailable }
    
    private let artworksRepository: IArtworksRepository
    
    init(artworksRepository: IArtworksRepository) {
        self.artworksRepository = artworksRepository
    }
    
    func fetchNextPage() {
        Task {
            do {
                if artworksRepository.nextPageAvailable {
                    self.arts.append(contentsOf: try await artworksRepository.getNextPage())
                }
            } catch {
                self.presentError(error)
            }
        }
    }
    
    func refreshList() {
        arts = []
        artworksRepository.resetPagination()
        fetchNextPage()
    }
    
    private func presentError(_ error: Error) {
        print(error)
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
