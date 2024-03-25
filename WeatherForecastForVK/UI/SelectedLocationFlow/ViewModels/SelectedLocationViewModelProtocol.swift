import Foundation
import Combine

protocol SelectedLocationViewModelProtocol {
    var weatherPublisher: AnyPublisher<TemperatureUIModel?, Never> { get }
    var numberOfSections: Int { get }
    var viewState: CurrentValueSubject<ViewState, Never> { get }
    
    func requestLocationAndWeather()
    func numberOfItems(inSection section: SelectedLocationSections) -> Int
    func weatherModelForIndexPath(_ indexPath: IndexPath) -> DayWeatherUIModel?
    
    func modelForIndexPath(_ indexPath: IndexPath) -> Any?
}
