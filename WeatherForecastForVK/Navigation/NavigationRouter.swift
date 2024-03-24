import UIKit

protocol NavigationRouterProtocol {
    func startNavigation()
    func navigateToOtherLocationViewController()
    func goBackToSelectetLocationViewController()
}

final class NavigationRouter: NavigationRouterProtocol {
    private let navigationController: UINavigationController
    private let weatherDataService: WeatherDataServiceProtocol
    private let geoLocationService: GeoLocationServiceProtocol
    private let weatherService: WeatherServiceProtocol
    private let layoutProvider: LayoutProviderProtocol
    
    init(navigationController: UINavigationController,
         geoLocationService: GeoLocationServiceProtocol = GeoLocationService(),
         weatherService: WeatherServiceProtocol = WeatherService(),
         layoutProvider: LayoutProviderProtocol = LayoutProvider()) {
        self.navigationController = navigationController
        self.weatherDataService = WeatherDataService(weatherService: weatherService)
        self.geoLocationService = geoLocationService
        self.weatherService = weatherService
        self.layoutProvider = layoutProvider
    }
    
    func startNavigation() {
        let viewModel = SelectedLocationViewModel(weatherDataService: weatherDataService,
                                                  geoLocationService: geoLocationService)
        let rootViewController = SelectedLocationViewController(router: self,
                                                                viewModel: viewModel,
                                                                layoutProvider: layoutProvider)
        navigationController.pushViewController(rootViewController, animated: false)
    }
    
    func navigateToOtherLocationViewController() {
        let viewModel = OtherLocationViewModel(weatherDataService: weatherDataService)
        let destVC = OtherLocationViewController(router: self, 
                                                 viewModel: viewModel)
        navigationController.pushViewController(destVC, animated: false)
    }
    
    func goBackToSelectetLocationViewController() {
        navigationController.popViewController(animated: true)
    }
}
