import Combine

protocol WeatherDataServiceProtocol {
    var weatherResponsePublisher: AnyPublisher<WeatherResponse?, Never> { get }
    var weatherLocationPublisher: AnyPublisher<LocationInfo?, Never> { get }

    func updateWeather(location: LocationInfo)
}
