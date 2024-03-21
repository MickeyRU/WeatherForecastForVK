import Combine
import CoreLocation

protocol SelectedLocationViewModelProtocol {
    var selectedLocationPublisher: AnyPublisher<SelectedLocationUIModel?, Never> { get }
    func requestLocationAndWeather()
}

final class SelectedLocationViewModel: SelectedLocationViewModelProtocol {
    var selectedLocationPublisher: AnyPublisher<SelectedLocationUIModel?, Never> {
        selectedLocationSubject.eraseToAnyPublisher()
    }
    
    private let locationService: LocationServiceProtocol
    private let weatherService: WeatherServiceProtocol
    
    private let selectedLocationSubject = CurrentValueSubject<SelectedLocationUIModel?, Never>(nil)
    
    private var cancellables: Set<AnyCancellable> = []
    
    
    init(locationService: LocationServiceProtocol, weatherService: WeatherServiceProtocol) {
        self.locationService = locationService
        self.weatherService = weatherService
        requestLocationAndWeather()
        setupBindings()
    }
    
    func requestLocationAndWeather() {
        locationService.requestLocation()
    }
    
    private func setupBindings() {
        locationService.currentLocationPublisher
            .sink { [weak self] selectedLocation in
                guard let self = self,
                      let selectedLocation = selectedLocation
                else { return }
                let uiModel = SelectedLocationUIModel(location: selectedLocation)
                self.selectedLocationSubject.send(uiModel)
            }
            .store(in: &cancellables)
    }
}
