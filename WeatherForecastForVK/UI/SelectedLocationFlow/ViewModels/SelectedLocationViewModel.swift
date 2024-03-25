import Foundation
import Combine

final class SelectedLocationViewModel: SelectedLocationViewModelProtocol {
    private (set) var viewState = CurrentValueSubject<ViewState, Never>(.loading)
    
    var numberOfSections: Int {
        return SelectedLocationSections.allCases.count
    }
    
    var weatherPublisher: AnyPublisher<TemperatureUIModel?, Never> {
        return currentWeatherSubject.eraseToAnyPublisher()
    }
    
    private let geoLocationService: GeoLocationServiceProtocol
    private let weatherDataService: AppDataServiceProtocol
    private var cancellables: Set<AnyCancellable> = []
    
    private let currentWeatherSubject = PassthroughSubject<TemperatureUIModel?, Never>()
    
    private var currentWeatherResponse: WeatherResponse? {
        didSet {
            viewState.value = currentWeatherResponse == nil ? .empty : .dataPresent
        }
    }
    
    init(weatherDataService: AppDataServiceProtocol,
         geoLocationService: GeoLocationServiceProtocol) {
        self.weatherDataService = weatherDataService
        self.geoLocationService = geoLocationService
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
              let dailyWeatherResponse = currentWeatherResponse?.daily[indexPath.row],
              let timezone = currentWeatherResponse?.timezone
        else {
            return nil
        }
        return DayWeatherUIModel(from: dailyWeatherResponse, timeZone: timezone)
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
        weatherDataService.weatherResponsePublisher
            .sink { [weak self] response in
                self?.currentWeatherResponse = response
            }
            .store(in: &cancellables)
        
        weatherDataService.locationPublisher
            .sink { [weak self] location in
                guard let self = self,
                      let location = location,
                      let weatherResponse = currentWeatherResponse
                else { return }
                self.updateTemperatureModel(with: weatherResponse, location: location)
            }
            .store(in: &cancellables)
        
        geoLocationService.currentLocationPublisher
            .sink { [weak self] selectedLocation in
                guard let self = self,
                      let selectedLocation = selectedLocation
                else { return }
                weatherDataService.updateWeather(location: selectedLocation)
            }
            .store(in: &cancellables)
    }
    
    private func updateTemperatureModel(with weatherResponse: WeatherResponse, location: LocationInfo) {
        let temperatureModel = TemperatureUIModel(location: location.placeName, with: weatherResponse)
        self.currentWeatherSubject.send(temperatureModel)
    }
}
