@testable import BitsoTest

class ListViewModelNavigationDelegateSpy: ListViewModelNavigationDelegate {
    private(set) var artworkItemDidSelectItem: Artwork?
    private(set) var artworkItemDidSelectWasCalled = false
    
    func artworkItemDidSelect(item: Artwork) {
        artworkItemDidSelectItem = item
        artworkItemDidSelectWasCalled = true
    }
}
