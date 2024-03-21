import Foundation

struct WeatherDataModel: Codable {
    let currentWeather: CurrentWeather
    let weeklyForecast: [DailyForecast]
}

struct CurrentWeather: Codable {
    let temperature: Double
    let windSpeed: Double
    let humidity: Int
}

struct DailyForecast: Codable {
    let date: Date
    let averageTemperature: Double
    let windSpeed: Double
    let humidity: Int
}
