import UIKit
import SwiftUI
import Combine

class DetailsViewController: UIHostingController<DetailsView> {
    
    var viewModel: DetailsViewModel?
    
    private var subscribers: [AnyCancellable] = []
    
    init(viewModel: DetailsViewModel) {
        self.viewModel = viewModel
        super.init(rootView: DetailsView(viewModel: viewModel))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBinds()
    }
    
    private func setBinds() {
        viewModel?
            .$errorMessage
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                guard let self else { return }
                let alertVC = UIAlertController(title: "Ops!!!", message: message, preferredStyle: .alert)
                alertVC.addAction(.init(title: "Ok", style: .default))
                present(alertVC, animated: true)
            }.store(in: &subscribers)
    }
}
