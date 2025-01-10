//
//  PlaceDTO.swift
//  PlaceFinder
//
//  Created by Eli Pacheco Hoyos on 9/01/25.
//

import Foundation
@testable import PlaceFinder

extension PlaceDTO {
    static var buenosAires: PlaceDTO {
        PlaceDTO(
            country: "AR",
            name: "Buenos Aires",
            id: 1,
            coordinate: .init(latitude: -34.6037, longitude: -58.3816)
        )
    }
    
    static var madrid: PlaceDTO {
        PlaceDTO(
            country: "ES",
            name: "Madrid",
            id: 2,
            coordinate: .init(latitude: 40.4167, longitude: -3.7033)
        )
    }
    
    static var bogota: PlaceDTO {
        PlaceDTO(
            country: "CO",
            name: "Bogota",
            id: 3,
            coordinate: .init(latitude: 4.6097, longitude: -74.0817)
        )
    }
    
    static var bogotaUppercased: PlaceDTO {
        PlaceDTO(
            country: "CO",
            name: "BOGOTA",
            id: 4,
            coordinate: .init(latitude: 4.6098, longitude: -74.0818)
        )
    }
    
}

extension Array where Element == PlaceDTO {
    static var all: [PlaceDTO] {
        [
            .buenosAires,
            .madrid,
            .bogota
        ]
    }
    
    static var allBogotas: [PlaceDTO] {
        [
            .bogota,
            .bogotaUppercased
        ]
    }
}
