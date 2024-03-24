import Foundation

extension String {
    // Функция принимает временную метку Unix и часовой пояс в формате строки , возвращает день недели
    static func dayOfWeek(from unixTimestamp: TimeInterval, timeZoneId: String) -> String {
        let date = Date(timeIntervalSince1970: unixTimestamp)

        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: timeZoneId)
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "E"
        
        return dateFormatter.string(from: date)
    }
    
    static func convertUnixTimeToLocaleTimeString(unixTime: TimeInterval, timeZoneIdentifier: String) -> String {
        let date = Date(timeIntervalSince1970: unixTime)
        let calendar = Calendar.current
        if let timeZone = TimeZone(identifier: timeZoneIdentifier) {
            var components = calendar.dateComponents(in: timeZone, from: date)
            if let hour = components.hour, let minute = components.minute {
                return String(format: "%02d:%02d", hour, minute)
            }
        }
        return "Время неизвестно"
    }
}
