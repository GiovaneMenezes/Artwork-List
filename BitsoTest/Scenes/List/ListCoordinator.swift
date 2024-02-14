import UIKit

final class ListCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    
    var detailsCoordinator: DetailsCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() -> UIViewController {
        let listViewModel = ListViewModel()
        listViewModel.navigationDelegate = self
        let listVC = ListViewController(viewModel: listViewModel)
        navigationController.pushViewController(listVC, animated: true)
        return navigationController
    }
}

extension ListCoordinator: ListViewModelNavigationDelegate {
    @MainActor func artworkItemDidSelect(item: Artwork) {
        let detailsCoordinator = DetailsCoordinator(navigationController: navigationController, artwork: item)
        self.detailsCoordinator = detailsCoordinator
        _ = detailsCoordinator.start()
    }
}
