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
        guard let weatherResponse = currentWeatherResponse else {
            return 0
        }
        switch section {
        case .weeklyForecast:
            return weatherResponse.daily.count
        case .selectedDayInfo:
            return CellIconType.allCases.count
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
    
    func modelForIndexPath(_ indexPath: IndexPath) -> Any? {
        guard indexPath.section == SelectedLocationSections.selectedDayInfo.rawValue else { return nil }
        
        switch indexPath.row {
        case 0:
            return getFeelsLikeModel()
        case 1:
            return getSunInfoModel()
        case 2:
            return getHumidityModel()
        case 3:
            return getWindModel()
        default:
            return nil
        }
    }
    
    private func getFeelsLikeModel() -> FeelsLikeUIModel? {
        guard let weatherResponse = currentWeatherResponse else {
            return nil
        }
        return FeelsLikeUIModel(weatherResponse: weatherResponse)
    }
    
    private func getSunInfoModel() -> SunInfoUIModel? {
        guard let weatherResponse = currentWeatherResponse else {
            return nil
        }
        return SunInfoUIModel(weatherResponse: weatherResponse)
    }
    
    private func getHumidityModel() -> HumidityUIModel? {
        guard let weatherResponse = currentWeatherResponse else {
            return nil
        }
        return HumidityUIModel(weatherResponse: weatherResponse)
    }
    
    private func getWindModel() -> WindUIModel? {
        guard let weatherResponse = currentWeatherResponse else {
            return nil
        }
        return WindUIModel(weatherResponse: weatherResponse)
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
