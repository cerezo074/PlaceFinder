//
//  PlaceDTO.swift
//  PlaceFinder
//
//  Created by Eli Pacheco Hoyos on 31/12/24.
//

struct PlaceDTO: Decodable {
    let country: String
    let name: String
    let id: Int
    let coordinate: CoordinateDTO
    
    enum CodingKeys: String, CodingKey {
        case country
        case name
        case id = "_id"
        case coordinate = "coord"
    }
}

struct CoordinateDTO: Codable {
    let lon: Double
    let lat: Double
}
