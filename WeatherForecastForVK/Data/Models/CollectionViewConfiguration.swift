import Foundation

protocol ConfigurableCell {
    static var reuseIdentifier: String { get }
    func configure(with model: WeatherUIModelProtocol)
}

enum SelectedLocationSections: Int, CaseIterable {
    case weeklyForecast
    case selectedDayInfo
}
