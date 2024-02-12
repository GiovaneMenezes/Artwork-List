import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start() -> UIViewController
    func stop()
}

// https://www.artic.edu/iiif/2/763257c8-fbf9-0377-54ab-ae3cee7ff7a4/full/843,/0/default.jpg
