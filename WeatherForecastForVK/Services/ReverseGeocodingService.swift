import CoreLocation

protocol ReverseGeocodingServiceProtocol {
    func getPlaceName(latitude: Double, longitude: Double, completion: @escaping (String?) -> Void)
}

final class ReverseGeocodingService: ReverseGeocodingServiceProtocol {
    func getPlaceName(latitude: Double, longitude: Double, completion: @escaping (String?) -> Void) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            guard error == nil else {
                print("Ошибка обратного геокодирования: \(error!.localizedDescription)")
                completion(nil)
                return
            }
            let placeName = placemarks?.first?.locality ?? placemarks?.first?.administrativeArea ?? placemarks?.first?.country ?? "Неизвестное место"
            completion(placeName)
        }
    }
}
