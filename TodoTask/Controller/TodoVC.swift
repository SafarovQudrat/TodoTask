import UIKit

class TodoVC: UIViewController {
    
    private var tableView: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.register(TodoCell.self, forCellReuseIdentifier: TodoCell.identifire)
        return table
    }()
    private let searchController = UISearchController(searchResultsController: nil)
    private var allTodos: [TodoTask] = []
    private var filteredTodos: [TodoTask] = []
    private let pageSize = 20
    private var currentPage = 0
    private var displayedTodos: [TodoTask] = []
    private var isLoading = false
    private let refresh = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apperenceSettings()
        setupSearch()
        loadInitialData()
        
    }
    
    override func viewDidLayoutSubviews() {
        setConstraints()
    }
    
    func apperenceSettings() {
        title = "Todo Task"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refresh
        refresh.addTarget(self, action: #selector(refreshTriggered), for: .valueChanged)
    }
    
    func setConstraints() {
        tableView.frame = view.bounds
    }
    private func setupSearch() {
            searchController.obscuresBackgroundDuringPresentation = false
            searchController.searchBar.placeholder = "Search by title or user name"
            searchController.searchResultsUpdater = self
            navigationItem.searchController = searchController
            definesPresentationContext = true
    }
    
    @objc private func refreshTriggered() {
            fetchAndUpdate()
    }
    
    private func loadInitialData() {
        if NetworkMonitor.shared.isConnected {
            fetchAndUpdate()
        } else {
            let cached = CoreDataManager.shared.fetchTodo()
            self.allTodos = cached
            self.applyFilterAndResetPagination()
        }
    }

    
    private func fetchAndUpdate() {
        guard !isLoading else {return}
        isLoading = true
        APIClient.shared.fetchTodosAndUsers { [weak self] result in
            DispatchQueue.main.async {
                self?.refresh.endRefreshing()
                self?.isLoading = false
                switch result {
                case .success(let data):
                    self?.allTodos = data
                    print("data = \(data)")
                    data.map { todo in
                        CoreDataManager.shared.saveTodoAndUser(todo: todo.todo, user: todo.user)
                    }
                    self?.applyFilterAndResetPagination()
                case .failure(let error):
                    print("Error \(error)")
                    
                }
            }
        }
    }
    
    private func applyFilterAndResetPagination() {
           applyFilter()
           currentPage = 0
           displayedTodos = []
           loadNextPage()
           tableView.reloadData()
       }
    private func applyFilter() {
           if let text = searchController.searchBar.text, !text.isEmpty {
               let searchText = text.lowercased()
               filteredTodos = allTodos.filter { task in
                   task.todo.title.lowercased().contains(searchText) ||
                   task.user.name.lowercased().contains(searchText)
               }
           } else {
               filteredTodos = allTodos
           }
       }
    private func loadNextPage() {
           guard displayedTodos.count < filteredTodos.count else { return }
           let start = currentPage * pageSize
           let end = min(start + pageSize, filteredTodos.count)
           guard start < end else { return }
           let nextSlice = filteredTodos[start..<end]
           displayedTodos.append(contentsOf: nextSlice)
           currentPage += 1
           tableView.reloadData()
       }
    
}

extension TodoVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        displayedTodos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoCell.identifire, for: indexPath) as? TodoCell else {
            return UITableViewCell()
        }
        
        cell.apperenceSettings(displayedTodos[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let offsetY = scrollView.contentOffset.y
            let contentHeight = scrollView.contentSize.height
            let frameHeight = scrollView.frame.size.height

            if offsetY > contentHeight - frameHeight - 100 { 
                loadNextPage()
            }
        }
}

extension TodoVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        applyFilterAndResetPagination()
    }
}
