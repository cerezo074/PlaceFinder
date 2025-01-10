//
//  PlaceEntityMock.swift
//  PlaceFinder
//
//  Created by Eli Pacheco Hoyos on 9/01/25.
//

import Foundation
@testable import PlaceFinder

extension PlaceEntity {
    static var buenosAires: PlaceEntity {
        PlaceEntity(
            country: "AR",
            name: "Buenos Aires",
            latitude: -34.6037,
            longitude: -58.3816,
            isFavorite: true
        )
    }
    
    static var madrid: PlaceEntity {
        PlaceEntity(
            country: "ES",
            name: "Madrid",
            latitude: 40.4167,
            longitude: -3.7033,
            isFavorite: true
        )
    }
    
    static var bogota: PlaceEntity {
        PlaceEntity(
            country: "CO",
            name: "Bogota",
            latitude: 4.6097,
            longitude: -74.0817,
            isFavorite: true
        )
    }
    
    static var bogotaUppercased: PlaceEntity {
        PlaceEntity(
            country: "CO",
            name: "BOGOTA",
            latitude: 4.6098,
            longitude: -74.0818,
            isFavorite: true
        )
    }
}
