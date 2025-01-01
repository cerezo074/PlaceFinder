//
//  CoordinateEntity.swift
//  PlaceFinder
//
//  Created by Eli Pacheco Hoyos on 31/12/24.
//


struct CoordinateEntity: Codable, Hashable {
    let lon: Double
    let lat: Double
    
    init(lon: Double, lat: Double) {
        self.lon = lon
        self.lat = lat
    }
    
    init(from DTO: CoordinateDTO) {
        self.lat = DTO.lat
        self.lon = DTO.lon
    }
}
