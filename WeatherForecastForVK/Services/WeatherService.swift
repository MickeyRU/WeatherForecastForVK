import Foundation
import Combine

protocol WeatherServiceProtocol {
    func fetchCurrentWeather(latitude: Double, longitude: Double, completion: @escaping (Result<WeatherResponse, Error>) -> Void)
}

final class WeatherService: WeatherServiceProtocol {
    private let apiKey = "cd4cf913ce9a5aa4d0711518d0c5f1e2"
    private let baseUrlString = "https://api.openweathermap.org/data/3.0/onecall"
    
    func fetchCurrentWeather(latitude: Double, longitude: Double, completion: @escaping (Result<WeatherResponse, Error>) -> Void) {
        let urlString = "\(baseUrlString)?lat=\(latitude)&lon=\(longitude)&units=metric&lang=ru&exclude=minutely,hourly,alerts&appid=\(apiKey)"
     
        guard let url = URL(string: urlString) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let weatherData = try decoder.decode(WeatherResponse.self, from: data)
                completion(.success(weatherData))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
