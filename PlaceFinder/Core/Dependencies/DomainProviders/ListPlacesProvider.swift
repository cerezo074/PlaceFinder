//
//  ListPlacesProvider.swift
//  PlaceFinder
//
//  Created by Eli Pacheco Hoyos on 30/12/24.
//

import Foundation

protocol ListPlacesProvider {
    var placesProvider: PlacesServices { get }
}

protocol PlacesServices {
    func loadData() async
    func getAllPlaces() async throws -> [PlaceModel]
}

class PlacesController: PlacesServices, PlaceValidatorServices {
    private unowned let repository: ListPlacesDataServices
    private unowned let validator: PlaceValidatorServices
    
    init(
        repository: ListPlacesDataServices,
        validator: PlaceValidatorServices
    ) {
        self.repository = repository
        self.validator = validator
    }

    func loadData() async {
        await repository.loadAllPlaces()
    }
    
    func getAllPlaces() async throws -> [PlaceModel] {
        try await repository.fetchAllPlaces()
    }
    
    func isLocationValid(lat: Double, lng: Double) async throws {
        try await validator.isLocationValid(lat: lat, lng: lng)
    }
}
