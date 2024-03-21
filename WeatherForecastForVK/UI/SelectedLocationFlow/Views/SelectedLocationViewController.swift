import UIKit
import Combine

final class SelectedLocationViewController: UIViewController {
    private let router: NavigationRouterProtocol
    private let viewModel: SelectedLocationViewModelProtocol
    
    private let bgImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .mainBackgroud
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let temperatureView = TemperatureView()
    private let footerView = FooterView()
    
    private var cancellables = Set<AnyCancellable>()
    
    init(router: NavigationRouterProtocol, viewModel: SelectedLocationViewModelProtocol) {
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
        setupViews()
    }
    
    private func setupBindings() {
        viewModel.selectedLocationPublisher
            .sink { [weak self] model in
                guard let self = self,
                      let model = model
                else { return }
                DispatchQueue.main.async {
                    self.temperatureView.updateUI(with: model)
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
        [bgImageView, footerView, temperatureView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        [bgImageView, footerView, temperatureView].forEach { view.addSubview($0) }
        
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
            footerView.heightAnchor.constraint(equalToConstant: 88)
        ])
    }
}
