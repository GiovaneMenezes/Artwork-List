import Foundation

protocol ListViewModelNavigationDelegate: AnyObject {
    func artworkItemDidSelect(item: Artwork)
}

protocol IListViewModel {
    var hasInternetConnection: Bool { get }
    var arts: [Artwork] { get }
    var artsPublisher: Published<[Artwork]>.Publisher { get }
    var errorMessage: String? { get }
    var errorMessagePublisher: Published<String?>.Publisher { get }
    var currentPage: Pagination? { get }
    func fetchNextPage() async
    func refreshList() async
    func title(for indexPath: IndexPath) -> String
    func subtitle(for indexPath: IndexPath) -> String
    func selectItem(at indexPath: IndexPath)
}

final class ListViewModel: IListViewModel {
    
    @Published private(set) var hasInternetConnection: Bool = true
    
    @Published private(set) var arts: [Artwork] = [Artwork]()
    var artsPublisher: Published<[Artwork]>.Publisher { $arts }
    
    @Published private(set) var errorMessage: String?
    var errorMessagePublisher: Published<String?>.Publisher { $errorMessage }
    
    private var isLoading = false
    
    private var nextPageAvailable: Bool {
        guard let currentPage = currentPage else { return true }
        return currentPage.currentPage < currentPage.totalPages
    }
    
    private(set) var currentPage: Pagination?
    
    private let artworksRepository: IArtworksRepository
    
    weak var navigationDelegate: ListViewModelNavigationDelegate?
    
    init(
        artworksRepository: IArtworksRepository = ArtworksRepository()
    ) {
        self.artworksRepository = artworksRepository
    }
    
    func fetchNextPage() async {
        await fetchPage(currentPage)
    }
    
    private func fetchPage(_ currentPage: Pagination?) async {
        do {
            guard (nextPageAvailable || currentPage == nil), !isLoading else { return }
            isLoading = true
            let page = try await artworksRepository.getArtworksPage(page: (currentPage?.currentPage ?? 0) + 1)
            if currentPage == nil {
                arts = page.data
            } else {
                arts.append(contentsOf: page.data)
            }
            self.currentPage = page.pagination
        } catch {
            presentError(error)
        }
        isLoading = false
    }
    
    func refreshList() async {
        await fetchPage(nil)
    }
    
    private func presentError(_ error: Error) {
        errorMessage = error.localizedDescription
    }
    
    func title(for indexPath: IndexPath) -> String {
        guard arts.indices.contains(indexPath.row) else { return "" }
        return arts[indexPath.row].title
    }
    
    func subtitle(for indexPath: IndexPath) -> String {
        guard arts.indices.contains(indexPath.row) else { return "" }
        return [
            arts[indexPath.row].artistTitles.count > 0 ? arts[indexPath.row].artistTitles.joined(separator: ", ") : nil,
            arts[indexPath.row].dateDisplay
        ].compactMap { $0 }.joined(separator: " - ")
    }
    
    func selectItem(at indexPath: IndexPath) {
        navigationDelegate?.artworkItemDidSelect(item: arts[indexPath.row])
    }
}
