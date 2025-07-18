//
//  FavoriteLocationViewModel.swift
//  Weather
//
//  Created by Jesús Lugo Sáenz on 08/02/25.
//

import Foundation
import UIKit

class FavoriteLocationViewModel {
    
    var weatherModel: WeatherModel
    private var regionName: [String]
    
    var numberOfSections: Int { 1 }
    var numberOfItemsInSection: Int { regionName.count }
    var cellIndentifier: String { "regionItem" }
    
    init() {
        weatherModel = WeatherModel.getInstance()
        regionName = Array(weatherModel.favoritesRegions.keys)
        
        NotificationCenter.default.addObserver(self, selector: #selector(saveFavoritesRegions), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    
    func getName(for indexPath: IndexPath) -> String{
        regionName[indexPath.row]
    }
    
    func getImage(for name: String) -> Country{
        weatherModel.favoritesRegions[name] ?? .brazil
    }
    
    func loadFavorites() {
        regionName = Array(weatherModel.favoritesRegions.keys)
    }
    
    @objc
    private func saveFavoritesRegions() {
        weatherModel.saveFavoriteData()
    }
}
