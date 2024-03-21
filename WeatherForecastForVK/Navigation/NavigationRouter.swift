import UIKit

protocol NavigationRouterProtocol {
    func startNavigation()
}

final class NavigationRouter: NavigationRouterProtocol {
    private let navigationController: UINavigationController
    private let locationService: LocationServiceProtocol
    private let weatherService: WeatherServiceProtocol
    
    init(navigationController: UINavigationController,
         locationService: LocationServiceProtocol = LocationService(),
         weatherService: WeatherServiceProtocol = WeatherService()) {
        self.navigationController = navigationController
        self.locationService = locationService
        self.weatherService = weatherService
    }
    
    func startNavigation() {
        let viewModel = SelectedLocationViewModel(locationService: locationService, weatherService: weatherService)
        let rootViewController = SelectedLocationViewController(router: self, viewModel: viewModel)
        navigationController.pushViewController(rootViewController, animated: false)
    }
}
