import Foundation

struct SelectedLocationUIModel {
    let location: String
    let temperature: String
    let weatherConditions: String
    let hTemperature: String
    let lTemperature: String
    
    init(location: LocationInfo) {
        self.location = location.placeName
        self.temperature = "-1°"
        self.weatherConditions = "Mostly Clear"
        self.hTemperature = "H:24"
        self.lTemperature = "L:24"
    }
}
