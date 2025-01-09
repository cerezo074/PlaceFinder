//
//  PlaceDTO.swift
//  PlaceFinder
//
//  Created by Eli Pacheco Hoyos on 31/12/24.
//

struct PlaceDTO: Decodable, Hashable {
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
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(country)
        hasher.combine(name)
        hasher.combine(coordinate)
    }
}

struct CoordinateDTO: Codable, Hashable {
    let latitude: Double
    let longitude: Double
    
    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
    }
}
