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
    
    func stop() {
        // No nescessary as it's not being called
    }
}

extension ListCoordinator: ListViewModelNavigationDelegate {
    func artworkItemDidSelect(item: Artwork) {
        let detailsCoordinator = DetailsCoordinator(navigationController: navigationController, artwork: item)
        self.detailsCoordinator = detailsCoordinator
        _ = detailsCoordinator.start()
    }
}
