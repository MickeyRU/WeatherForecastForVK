import Foundation

protocol ConfigurableCell {
    associatedtype Model
    static var reuseIdentifier: String { get }
    func configure(with model: Model)
}

enum SelectedLocationSections: Int, CaseIterable {
    case weeklyForecast
    case selectedDayInfo
}
