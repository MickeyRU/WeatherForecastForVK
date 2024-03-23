import Foundation

struct WeatherResponse: Codable {
    let lat: Float
    let lon: Float
    let timezone: String
    let current: CurrentWeatherResponse
    let daily: [DailyWeatherResponse]
}

struct CurrentWeatherResponse: Codable {
    let sunrise: Int
    let sunset: Int
    let temp: Float
    let feelsLike: Float
    let pressure: Int
    let humidity: Int
    let uvi: Float
    let windSpeed: Float
    let weather: [WeatherConditionResponse]
}

struct DailyWeatherResponse: Codable {
    let dt: Int
    let temp: TemperatureInfoResponse
    let weather: [WeatherConditionResponse]
}

struct TemperatureInfoResponse: Codable {
    let min: Float
    let max: Float
    let eve: Float
}

struct WeatherConditionResponse: Codable {
    let id: Int
    let main: String
    let description: String
}
