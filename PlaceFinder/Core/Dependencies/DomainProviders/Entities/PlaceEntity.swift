//
//  PlaceEntity.swift
//  PlaceFinder
//
//  Created by Eli Pacheco Hoyos on 31/12/24.
//

struct PlaceEntity: Codable, Hashable {
    let country: String
    let name: String
    let coordinate: CoordinateEntity
    
    init(country: String, name: String, coordinate: CoordinateEntity) {
        self.country = country
        self.name = name
        self.coordinate = coordinate
    }
    
    init(from DTO: PlaceDTO) {
        self.country = DTO.country
        self.name = DTO.name
        self.coordinate = CoordinateEntity(from: DTO.coordinate)
    }
}
