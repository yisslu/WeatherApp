//
//  LocationModel.swift
//  Weather
//
//  Created by Jesús Lugo Sáenz on 08/02/25.
//

struct LocationModel: Codable {
    var id: Int
    var locationName: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case locationName = "nombre"
    }
}
