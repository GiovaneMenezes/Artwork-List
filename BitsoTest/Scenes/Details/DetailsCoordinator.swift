import UIKit

class DetailsCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    var artwork: Artwork

    init(navigationController: UINavigationController, artwork: Artwork) {
        self.navigationController = navigationController
        self.artwork = artwork
    }
    
    @MainActor func start() -> UIViewController {
        let viewModel = DetailsViewModel(artwork: artwork)
        let detailsViewController = DetailsViewController(viewModel: viewModel)
        navigationController.pushViewController(detailsViewController, animated: true)
        return navigationController
    }
    
    func stop() {
        navigationController.popViewController(animated: true)
    }
}
