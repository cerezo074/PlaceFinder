//
//  PlaceModel.swift
//  PlaceFinder
//
//  Created by Eli Pacheco Hoyos on 31/12/24.
//

struct PlaceModel: Codable, Hashable {
    let country: String
    let name: String
    let coordinate: CoordinateModel
    
    init(country: String, name: String, coordinate: CoordinateModel) {
        self.country = country
        self.name = name
        self.coordinate = coordinate
    }
    
    init(from DTO: PlaceDTO) {
        self.country = DTO.country
        self.name = DTO.name
        self.coordinate = CoordinateModel(from: DTO.coordinate)
    }
    
    init(from entity: PlaceEntity) {
        self.country = entity.country
        self.name = entity.name
        self.coordinate = CoordinateModel(from: entity.coordinate)
    }
}
