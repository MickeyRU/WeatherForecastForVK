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
}
