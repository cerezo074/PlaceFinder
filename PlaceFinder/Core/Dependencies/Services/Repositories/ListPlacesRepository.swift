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
    private var favorites: Set<FavoritePlaceModel>
    
    init(
        networkServices: NetworkServices,
        placesDB: any Database<PlaceEntity>
    ) {
        self.placesDB = placesDB
        self.networkServices = networkServices
        inMemoryPlaces = []
        favorites = []
    }
    
    func loadAllPlaces() async {
        do {
            try loadFavorites()
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
        let favoritePlace = FavoritePlaceModel(from: place)

        if place.isFavorite, !favorites.contains(favoritePlace) {
            try placesDB.update(entity)
            favorites.insert(favoritePlace)
        } else {
            try placesDB.delete(entity)
            favorites.remove(favoritePlace)
        }
    }
    
    func getFavoritesPlaces(by prefix: String) -> [PlaceModel] {
        if prefix.isEmpty {
            return inMemoryPlaces
        }
        
        // TODO: Call trie and get all elements by the prefix string
        
        return []
    }
    
    private func loadFavorites() throws {
        let favoritePlaces = try placesDB.read(
            sortBy: SortDescriptor<PlaceEntity>(\.name), SortDescriptor<PlaceEntity>(\.country)
        )
        .map { FavoritePlaceModel(from: $0) }
        
        self.favorites = Set(favoritePlaces)
    }
    
    private func loadFromRemoteSource() async throws {
        let placesDTO = try await networkServices.fetchData(
            of: [PlaceDTO].self,
            with: PlaceEndpointTypes.fetchAll
        ) ?? []
        
        var placeModels: [PlaceModel] = []
        
        for placeDTO in placesDTO {
            var placeModel = PlaceModel(from: placeDTO)
            let favoriteModel = FavoritePlaceModel(from: placeModel)
            placeModel.isFavorite = favorites.contains(favoriteModel)
            placeModels.append(placeModel)
        }
                
        self.inMemoryPlaces = placeModels.sorted { leftModel, rightModel in
            leftModel.sortID < rightModel.sortID
        }
    }
}

