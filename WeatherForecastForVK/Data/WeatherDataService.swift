import Combine

final class WeatherDataService: WeatherDataServiceProtocol {    
    private let weatherService: WeatherServiceProtocol
    private var cancellables: Set<AnyCancellable> = []
    private let weatherResponseSubject = CurrentValueSubject<WeatherResponse?, Never>(nil)
    private let weatherLocation = CurrentValueSubject<LocationInfo?, Never>(nil)
    
    var weatherResponsePublisher: AnyPublisher<WeatherResponse?, Never> {
        weatherResponseSubject.eraseToAnyPublisher()
    }
    
    var weatherLocationPublisher: AnyPublisher<LocationInfo?, Never> {
        weatherLocation.eraseToAnyPublisher()
    }
    
    init(weatherService: WeatherServiceProtocol) {
        self.weatherService = weatherService
    }
    
    func updateWeather(location: LocationInfo) {
        weatherService.fetchCurrentWeather(latitude: location.latitude, longitude: location.longitude) { [weak self] result in
            switch result {
            case .success(let weatherResponse):
                self?.weatherResponseSubject.send(weatherResponse)
                self?.weatherLocation.send(location)
            case .failure(let error):
                ErrorHandler.handle(error: .networkError(error.localizedDescription))
            }
        }
    }
}
