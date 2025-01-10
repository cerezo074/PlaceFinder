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
    
    init(country: String, name: String, id: Int, coordinate: CoordinateDTO) {
        self.country = country
        self.name = name
        self.id = id
        self.coordinate = coordinate
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
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
    }
}
