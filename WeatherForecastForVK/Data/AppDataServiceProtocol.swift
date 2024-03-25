import Combine

protocol AppDataServiceProtocol {
    var weatherResponsePublisher: AnyPublisher<WeatherResponse?, Never> { get }
    var locationPublisher: AnyPublisher<LocationInfo?, Never> { get }

    func updateWeather(location: LocationInfo)
}
