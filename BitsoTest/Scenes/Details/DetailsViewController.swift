import UIKit
import SwiftUI

class DetailsViewController: UIHostingController<DetailsView> {
    
    init(viewModel: DetailsViewModel) {
        super.init(rootView: DetailsView(viewModel: viewModel))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
