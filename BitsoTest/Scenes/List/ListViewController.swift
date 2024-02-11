import UIKit
import Combine

class ListViewController: UIViewController {
    private var viewModel: ListViewModel
    
    private var subscribers: [AnyCancellable] = []
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.refreshControl = refreshControl
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        return refreshControl
    }()
    
    init(viewModel: ListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViews()
        setObservables()
        viewModel.fetchNextPage()
    }
    
    private func setViews() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        
        let constraints = [
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setObservables() {
        viewModel
            .$arts
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.refreshControl.endRefreshing()
                self?.tableView.reloadData()
            }.store(in: &subscribers)
    }
    
    @objc func pullToRefresh() {
        viewModel.refreshList()
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.arts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = viewModel.title(for: indexPath)
        content.secondaryText = viewModel.subtitle(for: indexPath)
        
        cell.contentConfiguration = content
        return cell
    }
}

extension ListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > tableView.contentSize.height - tableView.frame.size.height * 2 {
            viewModel.fetchNextPage()
        }
    }
}
