//
//  CoordinateModel.swift
//  PlaceFinder
//
//  Created by Eli Pacheco Hoyos on 31/12/24.
//

struct CoordinateModel: Codable, Hashable {
    let latitude: Double
    let longitude: Double
    
    init(latitude: Double, longitude: Double) {
        self.longitude = longitude
        self.latitude = latitude
    }
    
    init(from DTO: CoordinateDTO) {
        self.latitude = DTO.latitude
        self.longitude = DTO.longitude
    }

}
