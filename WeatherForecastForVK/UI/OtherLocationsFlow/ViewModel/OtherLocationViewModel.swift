import Foundation
import Combine
import MapKit

final class OtherLocationViewModel: OtherLocationViewModelProtocol {
    var locationsPublisher: AnyPublisher<[LocationInfo], Never> {
        locationsSubject.eraseToAnyPublisher()
    }
    
    private var cancellables: Set<AnyCancellable> = []
    private let locationsSubject = CurrentValueSubject<[LocationInfo], Never>([])
    private let weatherDataService: WeatherDataServiceProtocol

    init(weatherDataService: WeatherDataServiceProtocol) {
        self.weatherDataService = weatherDataService
    }
    
  
    func userSelectLocation (location: LocationInfo) {
        weatherDataService.updateWeather(location: location)
    }
    
    func performSearch(_ searchText: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        let search = MKLocalSearch(request: request)
        
        Future<[MKMapItem], Error> { promise in
            search.start { response, error in
                if let error = error {
                    promise(.failure(error))
                } else if let response = response {
                    promise(.success(response.mapItems))
                }
            }
        }
        .map { response in
            response.compactMap { item -> LocationInfo? in
                guard let coordinate = item.placemark.location?.coordinate else { return nil }
                return LocationInfo(latitude: coordinate.latitude, longitude: coordinate.longitude, placeName: item.name ?? "Unknown")
            }
        }
        .replaceError(with: [])
        .receive(on: DispatchQueue.main)
        .sink(receiveValue: { [weak self] locations in
            self?.locationsSubject.send(locations)
        })
        .store(in: &cancellables)
    }
}
