//
//  PlaceModelMock.swift
//  PlaceFinder
//
//  Created by Eli Pacheco Hoyos on 9/01/25.
//

import Foundation
@testable import PlaceFinder

extension PlaceModel {
    static var buenosAires: PlaceModel {
        PlaceModel(
            country: "AR",
            name: "Buenos Aires",
            coordinate: .init(latitude: -34.6037, longitude: -58.3816)
        )
    }
    
    static var madrid: PlaceModel {
        PlaceModel(
            country: "ES",
            name: "Madrid",
            coordinate: .init(latitude: 40.4167, longitude: -3.7033)
        )
    }
    
    static var bogota: PlaceModel {
        PlaceModel(
            country: "CO",
            name: "Bogota",
            coordinate: .init(latitude: 4.6097, longitude: -74.0817),
            isFavorite: false
        )
    }
    
    static var bogotaUppercased: PlaceModel {
        PlaceModel(
            country: "CO",
            name: "BOGOTA",
            coordinate: .init(latitude: 4.6098, longitude: -74.0818),
            isFavorite: true
        )
    }
    
    static var bogotaAsFavorite: PlaceModel {
        var model: PlaceModel = .bogota
        model.isFavorite = true
        
        return model
    }
    
    static var buenosAiresAsFavorite: PlaceModel {
        var model: PlaceModel = .buenosAires
        model.isFavorite = true
        
        return model
    }
    
}

extension Array where Element == PlaceModel {
    static var all: [PlaceModel] {
        [
            .buenosAires,
            .madrid,
            .bogota
        ]
    }
    
    static var allSortedBySortID: [PlaceModel] {
        all.sorted { leftModel, rightModel in
            leftModel.sortID < rightModel.sortID
        }
    }
    
    static var BPlacesSortedBySortID: [PlaceModel] {
        return [
            .bogotaAsFavorite,
            .buenosAiresAsFavorite
        ]
    }
}
