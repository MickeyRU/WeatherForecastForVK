import UIKit

protocol NavigationRouterProtocol {
    func startNavigation()
}

final class NavigationRouter: NavigationRouterProtocol {
    private let navigationController: UINavigationController
    private let geoLocationService: GeoLocationServiceProtocol
    private let reverseGeocodingService: ReverseGeocodingServiceProtocol
    private let weatherService: WeatherServiceProtocol
    private let layoutProvider: LayoutProviderProtocol
    
    init(navigationController: UINavigationController,
         geoLocationService: GeoLocationServiceProtocol = GeoLocationService(),
         reverseGeocodingService: ReverseGeocodingServiceProtocol = ReverseGeocodingService(),
         weatherService: WeatherServiceProtocol = WeatherService(),
         layoutProvider: LayoutProviderProtocol = LayoutProvider()) {
        self.navigationController = navigationController
        self.geoLocationService = geoLocationService
        self.reverseGeocodingService = reverseGeocodingService
        self.weatherService = weatherService
        self.layoutProvider = layoutProvider
    }
    
    func startNavigation() {
        let viewModel = SelectedLocationViewModel(geoLocationService: geoLocationService,
                                                  weatherService: weatherService,
                                                  reverseGeocodingService: reverseGeocodingService)
        let rootViewController = SelectedLocationViewController(router: self, viewModel: viewModel, layoutProvider: layoutProvider)
        navigationController.pushViewController(rootViewController, animated: false)
    }
}
