//
//  WeatherModel.swift
//  Weather
//
//  Created by Jesús Lugo Sáenz on 08/02/25.
//

import Foundation
import UIKit


class WeatherModel {
    
    private static var weatherModel: WeatherModel?
    
    private var apiKey: String?
    
    var weatherDTO: WeatherDTO?
    var image: UIImage?
    var favoritesRegions: [String:Country] = [:]
    
    private init(){
        apiKey = getAPIKey()
    }
    
    public static func getInstance() -> WeatherModel {
        if weatherModel == nil {
            weatherModel = WeatherModel()
        }
        
        return weatherModel!
    }
    
    private func getAPIKey() -> String {
        guard let filePath = Bundle.main.path(forResource: "Info", ofType: "plist") else {
          fatalError("Couldn't find file 'Info.plist'.")
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "API_KEY") as? String else {
          fatalError("Couldn't find key 'API_KEY' in 'Info.plist'.")
        }
        return value
    }
    
    func downloadPhoto(completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: "https:\(weatherDTO?.currentInfo.condition.iconCondition ?? "")") else { return }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) {
            [weak self] data, response, error in
            guard let data else {
                completion(nil)
                return
            }
            let image = UIImage(data: data)
            self?.image = image
            completion(image)
            
        }.resume()
    }
    
    func saveFavoriteData() {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            assertionFailure("Couldn't find documents directory")
            return
        }
        
        let fileName = "favorites-regions.json"
        
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        do {
            let jsonData = try JSONEncoder().encode(favoritesRegions)
            try jsonData.write(to: fileURL)
        } catch {
            assertionFailure("Failed to save data: \(error)")
        }
    }
    
    func fetchFavoriteData() {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            assertionFailure("Couldn't find documents directory")
            return
        }
        
        let fileName = "favorites-regions.json"
        
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        do {
            let favoriteRegionsData = try Data(contentsOf: fileURL)
            let favoriteRegions = try JSONDecoder().decode([String:Country].self, from: favoriteRegionsData)
            favoritesRegions = favoriteRegions
        } catch {
//            assertionFailure("Failed to save data: \(error)")
        }
    }
    
    func fetchWeatherData(for location: String, completionHandler: @escaping (Error?) -> Void) {
        guard let request = buildRequest(for: location) else { completionHandler(CommonErrors.badRequest)
            return
        }
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, taskError in
            guard let httpResponse = (response as? HTTPURLResponse) else {
                completionHandler(CommonErrors.unexpectedResponse)
                return
            }
            
            guard httpResponse.statusCode == 200 else {
                completionHandler(CommonErrors.badResponse(httpResponse.statusCode))
                return
            }
            guard let data else {
                completionHandler(CommonErrors.notFound)
                return
            }
            
            do {
                self?.weatherDTO = try JSONDecoder().decode(WeatherDTO.self, from: data)
                completionHandler(nil)
            } catch {
                completionHandler(error)
            }
        }.resume()
    }
    
    private func buildRequest(for location: String) -> URLRequest? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.weatherapi.com"
        components.queryItems = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "q", value: location),
            URLQueryItem(name: "aqi", value: "no")
        ]
        components.path = "/v1/current.json"
        guard let url = components.url else { return nil }
        
        return URLRequest(url: url)
    }
    
}
