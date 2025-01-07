//
//  PlaceEntity.swift
//  PlaceFinder
//
//  Created by Eli Pacheco Hoyos on 7/01/25.
//

import SwiftData
import Foundation

@Model
final class PlaceEntity: Hashable {
    
    @Attribute(.unique)
    private(set) var id: String
    private(set) var country: String
    private(set) var name: String
    private(set) var isFavorite: Bool
    var coordinate: CoordinateEntity?

    init(
        country: String,
        name: String,
        coordinate: CoordinateEntity?,
        isFavorite: Bool
    ) {
        self.id = "\(country),\(name),\(coordinate?.id ?? "")"
        self.country = country
        self.name = name
        self.coordinate = coordinate
        self.isFavorite = isFavorite
    }
    
    static func makeEntity(from DTO: PlaceDTO) -> PlaceEntity {
        let coordinate = CoordinateEntity(
            lon: DTO.coordinate.lon,
            lat: DTO.coordinate.lat
        )
        
        let entity = PlaceEntity(
            country: DTO.country,
            name: DTO.name,
            coordinate: coordinate,
            isFavorite: false
        )
        coordinate.place = entity
        
        return entity
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
