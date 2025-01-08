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
    private(set) var lon: Double
    private(set) var lat: Double
    var isFavorite: Bool
    
    init(
        country: String,
        name: String,
        lon: Double,
        lat: Double,
        isFavorite: Bool
    ) {
        self.id = "\(country),\(name),\(lat),\(lon)"
        self.country = country
        self.name = name
        self.lat = lat
        self.lon = lon
        self.isFavorite = isFavorite
    }
    
    convenience init(from DTO: PlaceDTO) {
        self.init(
            country: DTO.country,
            name: DTO.name,
            lon: DTO.coordinate.lon,
            lat: DTO.coordinate.lat,
            isFavorite: false
        )
    }
}
