//
//  ListPlacesRepository.swift
//  PlaceFinder
//
//  Created by Eli Pacheco Hoyos on 31/12/24.
//

import Foundation

protocol ListPlacesDataProvider {
    var listPlacesDataServices: ListPlacesDataServices { get }
}

protocol ListPlacesDataServices {
    func loadAllPlaces() async
    func fetchAllPlaces() async throws -> [PlaceEntity]
}

class ListPlacesRepository: ListPlacesDataServices {
    
    private let networkServices: NetworkServices
    private var inMemoryCache: [PlaceEntity] = []
    
    init(
        networkServices: NetworkServices
    ) {
        self.networkServices = networkServices
    }
    
    func loadAllPlaces() async {
        do {
            guard let placesDTO = try await networkServices.fetchData(
                of: [PlaceDTO].self,
                with: PlaceEndpointTypes.fetchAll
            ) else {
                return
            }
            
            inMemoryCache = placesDTO.map { PlaceEntity(from: $0) }
        } catch {
            print("Error: \(error)")
        }
        
        // TODO: Needs to retrieve it with SwiftData and first we will check againts data base.
    }
    
    func fetchAllPlaces() async throws -> [PlaceEntity] {
        if !inMemoryCache.isEmpty {
            return inMemoryCache
        }
        
        guard let placesDTO = try await networkServices.fetchData(
            of: [PlaceDTO].self,
            with: PlaceEndpointTypes.fetchAll
        ) else {
            return []
        }
        
        return placesDTO.map { PlaceEntity(from: $0) }
    }
    
}
