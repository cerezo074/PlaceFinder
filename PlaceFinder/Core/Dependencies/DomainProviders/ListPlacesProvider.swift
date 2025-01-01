//
//  ListPlacesProvider.swift
//  PlaceFinder
//
//  Created by Eli Pacheco Hoyos on 30/12/24.
//

import Foundation

protocol ListPlacesProvider {
    var listPlaces: ListPlaces { get }
}

protocol ListPlaces {
    func loadData() async
    func getAllPlaces() async throws -> [PlaceEntity]
}

class PlacesController: ListPlaces {
    private let repository: ListPlacesDataServices
    
    init(repository: ListPlacesDataServices) {
        self.repository = repository
    }

    func loadData() async {
        await repository.loadAllPlaces()
    }
    
    func getAllPlaces() async throws -> [PlaceEntity] {
        try await repository.fetchAllPlaces()
    }
}

