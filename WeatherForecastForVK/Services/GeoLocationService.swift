import CoreLocation
import Combine

protocol GeoLocationServiceProtocol {
    var currentLocationPublisher: AnyPublisher<LocationInfo?, Never> { get }
    func requestLocation()
}

final class GeoLocationService: NSObject, GeoLocationServiceProtocol {
    var currentLocationPublisher: AnyPublisher<LocationInfo?, Never> {
        currentLocationSubject.eraseToAnyPublisher()
    }
    
    private let locationManager: CLLocationManager
    private let currentLocationSubject = CurrentValueSubject<LocationInfo?, Never>(nil)
    
    init(locationManager: CLLocationManager = CLLocationManager()) {
        self.locationManager = locationManager
        super.init()
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    func requestLocation() {
        locationManager.requestLocation()
    }
    
    // Кодирование для получения CLPlacemark с данными по местонахождению
    private func getPlace(for location: CLLocation, completion: @escaping (CLPlacemark?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            guard error == nil else {
                print("Ошибка обратного геокодирования: \(error!.localizedDescription)")
                completion(nil)
                return
            }
            completion(placemarks?.first)
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension GeoLocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        getPlace(for: location) { [weak self] placemark in
            let locationInfo = LocationInfo(
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude,
                placeName: placemark?.locality ?? NSLocalizedString("Unknowed location", tableName: "Localizable", comment: "")
            )
            self?.currentLocationSubject.send(locationInfo)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Ошибка получения геолокации: \(error.localizedDescription)")
        currentLocationSubject.send(nil)
    }
}
