import Foundation
import Combine

final class SelectedLocationViewModel: SelectedLocationViewModelProtocol {
    var numberOfSections: Int {
        return SelectedLocationSections.allCases.count
    }
    
    var weatherPublisher: AnyPublisher<TemperatureUIModel?, Never> {
        return currentWeatherSubject.eraseToAnyPublisher()
    }
    
    private let geoLocationService: GeoLocationServiceProtocol
    private let weatherService: WeatherServiceProtocol
    private let reverseGeocodingService: ReverseGeocodingServiceProtocol
    
    private let currentWeatherSubject = PassthroughSubject<TemperatureUIModel?, Never>()
    
    private var currentWeatherResponse: WeatherResponse? {
        didSet {
            updateTemperatureModel(with: currentWeatherResponse)
        }
    }
    
    private var cancellables: Set<AnyCancellable> = []
    
    
    init(geoLocationService: GeoLocationServiceProtocol,
         weatherService: WeatherServiceProtocol,
         reverseGeocodingService: ReverseGeocodingServiceProtocol) {
        self.geoLocationService = geoLocationService
        self.weatherService = weatherService
        self.reverseGeocodingService = reverseGeocodingService
        requestLocationAndWeather()
        setupBindings()
    }
    
    func requestLocationAndWeather() {
        geoLocationService.requestLocation()
    }
    
    
    func numberOfItems(inSection section: SelectedLocationSections) -> Int {
        guard 
            section == .weeklyForecast,
            let weatherResponse = currentWeatherResponse else {
            return 0
        }
        switch section {
        case .weeklyForecast:
            return weatherResponse.daily.count
        case .selectedDayInfo:
            return 7
        }
    }
    
    func weatherModelForIndexPath(_ indexPath: IndexPath) -> DayWeatherUIModel? {
        guard indexPath.section == SelectedLocationSections.weeklyForecast.rawValue,
              indexPath.row < currentWeatherResponse?.daily.count ?? 0,
              let dailyWeatherResponse = currentWeatherResponse?.daily[indexPath.row]
        else {
            return nil
        }
        return DayWeatherUIModel(from: dailyWeatherResponse, timeZone: currentWeatherResponse!.timezone)
    }
    
    private func setupBindings() {
        geoLocationService.currentLocationPublisher
            .sink { [weak self] selectedLocation in
                guard let self = self,
                      let selectedLocation = selectedLocation
                else { return }
                
                weatherService.fetchCurrentWeather(latitude: selectedLocation.latitude, longitude: selectedLocation.longitude) { result in
                    switch result {
                    case .success(let weatherResponse):
                        self.currentWeatherResponse = weatherResponse
                    case .failure(let error):
                        print("Ошибка получения данных о погоде: \(error.localizedDescription)")
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    
    private func updateTemperatureModel(with weatherResponse: WeatherResponse?) {
        guard let weatherResponse = weatherResponse else { return }
        
        reverseGeocodingService.getPlaceName(latitude: Double(weatherResponse.lat),
                                             longitude: Double(weatherResponse.lon)) { [weak self] placeName in
            guard 
                let self = self,
                let placeName = placeName
            else { return }
            
            let temperatureModel = TemperatureUIModel(location: placeName, with: weatherResponse)
            self.currentWeatherSubject.send(temperatureModel)
        }
    }
}
