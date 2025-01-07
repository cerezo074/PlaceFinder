//
//  CoordinateEntity.swift
//  PlaceFinder
//
//  Created by Eli Pacheco Hoyos on 7/01/25.
//

import SwiftData

@Model
final class CoordinateEntity {
    
    @Attribute(.unique)
    private(set) var id: String
    private(set) var lon: Double
    private(set) var lat: Double
    var place: PlaceEntity?
    
    init(lon: Double, lat: Double, place: PlaceEntity? = nil) {
        self.id = "\(lat),\(lon)"
        self.lon = lon
        self.lat = lat
        self.place = place
    }
    
    convenience init(from DTO: CoordinateDTO) {
        self.init(lon: DTO.lon, lat: DTO.lat)
    }
}
