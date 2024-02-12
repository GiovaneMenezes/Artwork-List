import Foundation

protocol IListViewModel {
    
}

class ListViewModel {
    
    @Published private(set) var hasInternetConnection: Bool = true
    @Published private(set) var arts: [Artwork] = [Artwork]()
    @Published private(set) var errorMessage: String?
    
    private var isLoading = false
    
    private var nextPageAvailable: Bool {
        guard let currentPage = currentPage else { return true }
        return currentPage.currentPage < currentPage.totalPages
    }
    
    private(set) var currentPage: Pagination?
    
    private let artworksRepository: IArtworksRepository
    
    init(artworksRepository: IArtworksRepository) {
        self.artworksRepository = artworksRepository
    }
    
    func fetchNextPage() async {
        await fetchPage(currentPage)
    }
    
    private func fetchPage(_ currentPage: Pagination?) async {
        do {
            guard nextPageAvailable, !isLoading else { return }
            isLoading = true
            let page = try await artworksRepository.getArtworksPage(page: (currentPage?.currentPage ?? 0) + 1)
            if currentPage == nil {
                arts = page.data
            } else {
                arts.append(contentsOf: page.data)
            }
            self.currentPage = page.pagination
            isLoading = false
        } catch {
            presentError(error)
            isLoading = false
        }
    }
    
    func refreshList() async {
        await fetchPage(nil)
    }
    
    private func presentError(_ error: Error) {
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
