//
//  DetailWeatherViewModel.swift
//  Weather
//
//  Created by Jesús Lugo Sáenz on 11/02/25.
//

import Foundation
import UIKit

class DetailWeatherViewModel {
    
    var locationName: String
    private var weatherInfo: WeatherDTO?
    private var weatherModel: WeatherModel
    var image: Country
    
    init(locationName: String, image: Country){
        self.locationName = locationName
        weatherModel = WeatherModel.getInstance()
        self.image = image
    }
    
    func getRegion() -> String {
        weatherModel.weatherDTO?.location.region ?? ""
    }
    
    func getLocalTime() -> String {
        changeDateFormat(for: weatherModel.weatherDTO!.location.localTime)
    }
    
    func getLastUpdate() -> String {
        "Last update: \(changeDateFormat(for: weatherModel.weatherDTO!.currentInfo.lastUpdate))"
    }
    
    func getCelcius() -> String{
        "\(weatherModel.weatherDTO!.currentInfo.celciusTemperature)°"
    }
    
    func getFahrenheit() -> String{
        "\(weatherModel.weatherDTO!.currentInfo.fahrenheitTemperature)°"
    }
    
    func getUvIndex() -> String{
        "UV: \(weatherModel.weatherDTO!.currentInfo.uvIndex)"
    }
    
    func isDay() -> Int {
        weatherModel.weatherDTO?.currentInfo.isDay ?? 0
    }
    
    func isFavorite() -> Bool{
        weatherModel.favoritesRegions.keys.contains(locationName) ? true : false
    }
    
    func saveToFavorites() {
        weatherModel.favoritesRegions[locationName] = image
        print(weatherModel.favoritesRegions)
    }
    
    func deleteFromFavorites() {
        if isFavorite() {
            weatherModel.favoritesRegions.removeValue(forKey: locationName)
        }
        print(weatherModel.favoritesRegions)
    }
    
    func changeDateFormat(for date: String) -> String{
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        guard let date = inputFormatter.date(from: date) else { return "" }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        let formattedDate = outputFormatter.string(from: date)
        
        return formattedDate
    }
    
}
