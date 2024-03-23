import Foundation
import Combine

protocol SelectedLocationViewModelProtocol {
    var weatherPublisher: AnyPublisher<TemperatureUIModel?, Never> { get }
    var numberOfSections: Int { get }
    
    func requestLocationAndWeather()
    func numberOfItems(inSection section: SelectedLocationSections) -> Int
    func weatherModelForIndexPath(_ indexPath: IndexPath) -> DayWeatherUIModel?
}
