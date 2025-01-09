//
//  ListPlacesRepository.swift
//  PlaceFinder
//
//  Created by Eli Pacheco Hoyos on 31/12/24.
//

import Foundation

protocol ListPlacesDataProvider {
    var listPlacesDataProvider: ListPlacesDataServices { get }
}

protocol ListPlacesDataServices: AnyObject {
    func loadAllPlaces() async
    func fetchAllPlaces() async throws -> [PlaceModel]
    func update(place: PlaceModel) throws
    func getFavoritesPlaces(by prefix: String) -> [PlaceModel]
}

class ListPlacesRepository: ListPlacesDataServices {
    private let networkServices: NetworkServices
    private let placesDB: any Database<PlaceEntity>
    private var inMemoryPlaces: [PlaceModel]
    
    init(
        networkServices: NetworkServices,
        placesDB: any Database<PlaceEntity>
    ) {
        self.placesDB = placesDB
        self.networkServices = networkServices
        inMemoryPlaces = []
    }
    
    func loadAllPlaces() async {
        do {
            inMemoryPlaces = try loadFromLocalSource()
            
            if !inMemoryPlaces.isEmpty {
                return
            }
            
            try await loadFromRemoteSource()
        } catch {
            print("Error: \(error)")
        }
    }
    
    func fetchAllPlaces() async throws -> [PlaceModel] {
        if !inMemoryPlaces.isEmpty {
            return inMemoryPlaces
        }
        
        guard let placesDTO = try await networkServices.fetchData(
            of: [PlaceDTO].self,
            with: PlaceEndpointTypes.fetchAll
        ) else {
            return []
        }
        
        return placesDTO.map { PlaceModel(from: $0) }
    }
    
    func update(place: PlaceModel) throws {
        let entity = PlaceEntity(from: place)
        try placesDB.update(entity)
        
        // TODO: Update the trie if the place is favorite or not insert/remove it.
        
        if let placeIndex = inMemoryPlaces.firstIndex(where: { $0.id == place.id }) {
            inMemoryPlaces[placeIndex] = place
        }
    }
    
    func getFavoritesPlaces(by prefix: String) -> [PlaceModel] {
        if prefix.isEmpty {
            return inMemoryPlaces
        }
        
        // TODO: Call trie and get all elements by the prefix string
        
        return []
    }
    
    private func loadFromLocalSource() throws -> [PlaceModel] {
        // TODO: We gotta read it by batches and not all at once like with a pagination
        return try placesDB.read(
            sortBy: SortDescriptor<PlaceEntity>(\.name), SortDescriptor<PlaceEntity>(\.country)
        )
        .map { PlaceModel(from: $0) }
    }
    
    private func loadFromRemoteSource() async throws {
        let placesDTO = try await networkServices.fetchData(
            of: [PlaceDTO].self,
            with: PlaceEndpointTypes.fetchAll
        ) ?? []
        
        
        // This is done in parallel, there is not need to make users wait for this
        Task {
            // Removes possible duplicates
            let placesDTOSet = Set(placesDTO)
            let placesEntities = placesDTOSet.map { PlaceEntity(from: $0) }
            do {
                try placesDB.create(placesEntities)
            } catch {
                print("Error saving places entities to database: \(error)")
            }
        }
        
        inMemoryPlaces = placesDTO
            .map { PlaceModel(from: $0) }
            .sorted { leftModel, rightModel in
                leftModel.name < rightModel.name && leftModel.country < rightModel.country
            }
    }
    
}

