//
//  PlaceEntity.swift
//  PlaceFinder
//
//  Created by Eli Pacheco Hoyos on 7/01/25.
//

import SwiftData
import Foundation

@Model
final class PlaceEntity {
    
    @Attribute(.unique)
    private(set) var id: String
    private(set) var country: String
    private(set) var name: String
    private(set) var latitude: Double
    private(set) var longitude: Double
    var isFavorite: Bool
    
    init(
        country: String,
        name: String,
        latitude: Double,
        longitude: Double,
        isFavorite: Bool
    ) {
        self.id = "\(country),\(name),\(latitude),\(longitude)"
        self.country = country
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.isFavorite = isFavorite
    }
    
    convenience init(from DTO: PlaceDTO) {
        self.init(
            country: DTO.country,
            name: DTO.name,
            latitude: DTO.coordinate.latitude,
            longitude: DTO.coordinate.longitude,
            isFavorite: false
        )
    }
    
    convenience init(from model: PlaceModel) {
        self.init(
            country: model.country,
            name: model.name,
            latitude: model.coordinate.latitude,
            longitude: model.coordinate.longitude,
            isFavorite: model.isFavorite
        )
    }
}
