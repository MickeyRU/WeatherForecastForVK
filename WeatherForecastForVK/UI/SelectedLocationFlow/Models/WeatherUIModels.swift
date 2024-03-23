import Foundation

struct DayWeatherUIModel {
    let dayOfWeek: String
    let averageTemperature: String
    let weatherIconName: String
    
    init(from dailyWeatherResponse: DailyWeatherResponse, timeZone: String) {
        // Преобразование Unix timestamp в день недели
        self.dayOfWeek = String.dayOfWeek(from: TimeInterval(dailyWeatherResponse.dt), timeZoneId: timeZone)
        self.averageTemperature = "\(Int(round(dailyWeatherResponse.temp.eve)))°"
        
        // Использование id погодного условия для выбора названия иконки
        if let weatherCondition = dailyWeatherResponse.weather.first?.id {
            self.weatherIconName = WeatherIconMapping.shared.iconName(for: weatherCondition)
        } else {
            self.weatherIconName = "01d"
        }
    }
}

struct TemperatureUIModel {
    let location: String
    let temperature: String
    let highTemperature: String
    let lowTemperature: String
    let weatherDescription: String
    
    init(location: String, with weatherResponse: WeatherResponse) {
        self.location = location
        self.temperature = "\(Int(round(weatherResponse.current.temp)))°"
        self.highTemperature = "Макс.: \(Int(round(weatherResponse.daily.first?.temp.max ?? 0)))°"
        self.lowTemperature = "Мин.: \(Int(round(weatherResponse.daily.first?.temp.min ?? 0)))°"
        self.weatherDescription = weatherResponse.current.weather.first?.description ?? "N/A"
    }
}

struct FeelsLikeUIModel {
    let n = 10
}
