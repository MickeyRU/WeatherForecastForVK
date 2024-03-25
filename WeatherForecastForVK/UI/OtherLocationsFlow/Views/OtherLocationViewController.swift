import UIKit
import MapKit
import Combine

final class OtherLocationViewController: UIViewController {
    private let router: NavigationRouterProtocol
    private let viewModel: OtherLocationViewModelProtocol
    
    private let bgImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .mainBackgroud
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        return searchBar
    }()
    
    private lazy var cityTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.register(CityCell.self, forCellReuseIdentifier: CityCell.reuseIdentifier)
        return tableView
    }()
    
    private var cancellables = Set<AnyCancellable>()
    private var searchResults = [LocationInfo]()
    
    init(router: NavigationRouterProtocol,
        viewModel: OtherLocationViewModelProtocol) {
        self.router = router
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupBindings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupViews()
        
        navigationController?.navigationBar.tintColor = .primaryWhiteBlack
    }
    
    private func setupBindings() {
        viewModel.locationsPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] locations in
                self?.searchResults = locations
                self?.cityTableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = NSLocalizedString("EnterLocationName", tableName: "Localizable", comment: "")
        searchBar.tintColor = .primaryWhiteBlack
        searchBar.searchTextField.tintColor = .primaryWhiteBlack
        searchBar.searchTextField.textColor = .primaryWhiteBlack
        
        let placeholderAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white]
        let attributedPlaceholder = NSAttributedString(string: searchBar.placeholder ?? "", attributes: placeholderAttributes)
        searchBar.searchTextField.attributedPlaceholder = attributedPlaceholder
        
        if let glassIconView =  searchBar.searchTextField.leftView as? UIImageView {
            glassIconView.image = glassIconView.image?.withRenderingMode(.alwaysTemplate)
            glassIconView.tintColor = .primaryWhiteBlack
        }
        
        navigationItem.titleView = searchBar
    }
    
    private func setupViews() {
        [bgImageView, cityTableView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        [bgImageView, cityTableView].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            bgImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bgImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bgImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bgImageView.topAnchor.constraint(equalTo: view.topAnchor),
            
            cityTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            cityTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            cityTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cityTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

// MARK: - UISearchBarDelegate

extension OtherLocationViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        viewModel.performSearch(searchText)
    }
}

// MARK: - UITableViewDataSource

extension OtherLocationViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CityCell.reuseIdentifier, for: indexPath) as? CityCell else {
            return UITableViewCell()
        }
        
        let location = searchResults[indexPath.row]
        cell.textLabel?.text = location.placeName
        cell.textLabel?.textColor = .primaryWhiteBlack
        cell.selectionStyle = .none
        
        return cell
    }
}

extension OtherLocationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = searchResults[indexPath.row]
        viewModel.userSelectLocation(location: location)
        router.goBackToSelectetLocationViewController()
    }
}
