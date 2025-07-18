//
//  CountryListViewModel.swift
//  Weather
//
//  Created by Jesús Lugo Sáenz on 08/02/25.
//

import Foundation
import UIKit

class CountryListViewModel {
    
    private let locationListDataName = "LocationList"
    private let dataExtension = "json"
    private var countries: [Int : Country] = [
        1: .london,
        2: .canada,
        3: .mexico,
        4: .brazil,
        5: .argentina,
        6: .spain,
        7: .france,
        8: .germany,
        9: .japan,
        10: .china
    ]

    
    var locationsList: [LocationModel] = []
    var cellIdentifier: String { "CountryListTableViewCell" }
    var numberOfRows: Int { locationsList.count }
    var numberOfSections: Int { 1 }
    
    init(){
        locationsList = fetchLocationList()
    }
    
    private func fetchLocationList() -> [LocationModel]{
        guard let fileURL = Bundle.main.url(forResource: locationListDataName, withExtension: dataExtension), let locationsData = try? Data(contentsOf: fileURL), let locationList = try? JSONDecoder().decode([LocationModel].self, from: locationsData) else {
            assertionFailure("Cannot find \(locationListDataName).\(dataExtension)")
            return []
        }
        
        return locationList
    }
    
    func  getLocationId(for indexPath: IndexPath) -> Int{
        locationsList[indexPath.row].id
    }
    
    func getLocationName(for indexPath: IndexPath) -> String {
        locationsList[indexPath.row].locationName
    }
    
    func getImage(for indexPath: IndexPath) -> Country{
        let countryId = getLocationId(for: indexPath)
        for (key,value) in countries {
            if key == countryId{
                return value
            }
        }
        
        return .argentina
    }
}

enum Country: String, Codable {
    case london = "London"
    case canada = "CanadáCA"
    case mexico = "Mexico"
    case brazil = "Brazil"
    case argentina = "Argentina"
    case spain = "Spain"
    case france = "France"
    case germany = "Germany"
    case japan = "Japan"
    case china = "China"
}

