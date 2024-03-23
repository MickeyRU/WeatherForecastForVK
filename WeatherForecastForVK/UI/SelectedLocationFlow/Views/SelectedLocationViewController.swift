import UIKit
import Combine

final class SelectedLocationViewController: UIViewController {
    private let router: NavigationRouterProtocol
    private let viewModel: SelectedLocationViewModelProtocol
    private let layoutProvider: LayoutProviderProtocol
    
    private let bgImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .mainBackgroud
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private let temperatureView = TemperatureView()
    private let footerView = FooterView()
    
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var weatherConditionsCollectionView: UICollectionView = {
        let layout = layoutProvider.createSelectedLocationLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .collectionViewBG.withAlphaComponent(0.5)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.layer.cornerRadius = 44
        collectionView.layer.borderWidth = 1
        collectionView.layer.borderColor = UIColor.brd.cgColor
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 88, right: 0)
        collectionView.register(DayWeatherCell.self, forCellWithReuseIdentifier: DayWeatherCell.reuseIdentifier)
        collectionView.register(FeelsLikeCell.self, forCellWithReuseIdentifier: FeelsLikeCell.reuseIdentifier)
        return collectionView
    }()
    
    init(router: NavigationRouterProtocol,
         viewModel: SelectedLocationViewModelProtocol,
         layoutProvider: LayoutProviderProtocol) {
        self.router = router
        self.viewModel = viewModel
        self.layoutProvider = layoutProvider
        super.init(nibName: nil, bundle: nil)
        setupBindings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupBindings() {
        viewModel.weatherPublisher
            .sink { [weak self] model in
                guard let self = self,
                      let model = model
                else { return }
                DispatchQueue.main.async {
                    self.temperatureView.configure(with: model)
                    self.weatherConditionsCollectionView.reloadData()
                }
            }
            .store(in: &cancellables)
        
        footerView.userLocationButtonTappedPublisher
            .sink {[weak self] _ in
                self?.viewModel.requestLocationAndWeather()
            }
            .store(in: &cancellables)
    }
    
    private func setupViews() {
        [bgImageView, temperatureView, weatherConditionsCollectionView, footerView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        [bgImageView, temperatureView, weatherConditionsCollectionView, footerView].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            bgImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bgImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bgImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bgImageView.topAnchor.constraint(equalTo: view.topAnchor),
            
            temperatureView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            temperatureView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            temperatureView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            temperatureView.heightAnchor.constraint(equalToConstant: view.bounds.height / 4),
            
            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerView.heightAnchor.constraint(equalToConstant: 88),
            
            weatherConditionsCollectionView.topAnchor.constraint(equalTo: temperatureView.bottomAnchor, constant: 20),
            weatherConditionsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            weatherConditionsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            weatherConditionsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UICollectionViewDataSource

extension SelectedLocationViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let productCardSection = SelectedLocationSections(rawValue: section) else {
            return 0
        }
        return viewModel.numberOfItems(inSection: productCardSection)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = SelectedLocationSections(rawValue: indexPath.section) else {
            return UICollectionViewCell()
        }
        
        switch section {
        case .weeklyForecast:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DayWeatherCell.reuseIdentifier, for: indexPath) as? DayWeatherCell,
                  let model = viewModel.weatherModelForIndexPath(indexPath) else {
                return UICollectionViewCell()
            }
            cell.configure(with: model)
            return cell
            
        case .selectedDayInfo:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeelsLikeCell.reuseIdentifier, for: indexPath) as? FeelsLikeCell else {
                return UICollectionViewCell()
            }
            return cell
        }
    }
}


// MARK: - UICollectionViewDelegate

extension SelectedLocationViewController: UICollectionViewDelegate {}
