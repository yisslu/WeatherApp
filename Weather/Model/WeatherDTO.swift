//
//  WeatherDTO.swift
//  Weather
//
//  Created by Jesús Lugo Sáenz on 11/02/25.
//

import Foundation

struct WeatherDTO: Codable {
    
    struct LocationData: Codable {
        let region: String
        let latitude: Double
        let longitude: Double
        let localTime: String
        
        private enum CodingKeys: String, CodingKey {
            case region
            case latitude = "lat"
            case longitude = "lon"
            case localTime = "localtime"
        }
    }
    
    struct CurrentData: Codable{
        
        struct Condition: Codable {
            let iconCondition: String
            
            private enum CodingKeys: String, CodingKey {
                case iconCondition = "icon"
            }
        }
        
        let lastUpdate: String
        let fahrenheitTemperature: Double
        let celciusTemperature: Double
        let isDay: Int
        let condition: Condition
        let uvIndex: Double
        
        private enum CodingKeys: String, CodingKey {
            case condition
            case lastUpdate = "last_updated"
            case fahrenheitTemperature = "temp_f"
            case celciusTemperature = "temp_c"
            case isDay = "is_day"
            case uvIndex = "uv"
        }
    }
    
    let location: LocationData
    let currentInfo: CurrentData
    
    private enum CodingKeys: String, CodingKey {
        case location
        case currentInfo = "current"
    }
}
