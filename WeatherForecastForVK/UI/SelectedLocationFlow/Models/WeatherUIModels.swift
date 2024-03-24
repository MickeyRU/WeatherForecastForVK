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


protocol WeatherUIModelProtocol {
    var iconType: CellIconType { get }
    init(iconType: CellIconType, weatherResponse: WeatherResponse)
}


struct FeelsLikeUIModel: WeatherUIModelProtocol {
    let iconType: CellIconType
    let temperature: String

    
    init(iconType: CellIconType = .feelsLike, weatherResponse: WeatherResponse) {
        self.iconType = iconType
        self.temperature = "\(Int(round(weatherResponse.current.feelsLike)))°"
    }
}

struct SunInfoUIModel: WeatherUIModelProtocol {
    let iconType: CellIconType
    let sunrise: String
    let sunset: String
    
    init(iconType: CellIconType = .sunInfo, weatherResponse: WeatherResponse) {
        self.iconType = iconType
        self.sunrise = String.convertUnixTimeToLocaleTimeString(unixTime: Double(weatherResponse.current.sunrise), 
                                                                timeZoneIdentifier: weatherResponse.timezone)
        let sunsetString = NSLocalizedString("sunset", tableName: "Localizable", comment: "")
        let sunsetValue = String.convertUnixTimeToLocaleTimeString(unixTime: Double(weatherResponse.current.sunset),
                                                                   timeZoneIdentifier: weatherResponse.timezone)
        self.sunset = sunsetString + ": " + sunsetValue
    }
}

struct HumidityUIModel: WeatherUIModelProtocol {
    let iconType: CellIconType
    
    init(iconType: CellIconType = .humidity, weatherResponse: WeatherResponse) {
        self.iconType = iconType
    }
}

struct WindUIModel: WeatherUIModelProtocol {
    let iconType: CellIconType
    
    init(iconType: CellIconType = .wind, weatherResponse: WeatherResponse) {
        self.iconType = iconType
    }
}
