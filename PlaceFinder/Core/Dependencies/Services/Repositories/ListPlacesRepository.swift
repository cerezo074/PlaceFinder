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
    private var favoritesContainer: Set<FavoritePlaceModel>
    private var favoritesTrie: Trie
    
    init(
        networkServices: NetworkServices,
        placesDB: any Database<PlaceEntity>
    ) {
        self.placesDB = placesDB
        self.networkServices = networkServices
        inMemoryPlaces = []
        favoritesContainer = []
        favoritesTrie = Trie()
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
        
        if place.isFavorite, !favoritesContainer.contains(favoritePlace) {
            try placesDB.update(entity)
            favoritesContainer.insert(favoritePlace)
            favoritesTrie.insert(word: favoritePlace.uniqueID)
        } else {
            try placesDB.delete(entity)
            favoritesTrie.remove(word: favoritePlace.uniqueID)
            favoritesContainer.remove(favoritePlace)
        }
        
        let inMemoryIndex = inMemoryPlaces.firstIndex { $0.uniqueID == place.uniqueID }

        if let index = inMemoryIndex {
            inMemoryPlaces[index] = place
        }
    }
    
    func getFavoritesPlaces(by word: String) -> [PlaceModel] {
        if word.isEmpty {
            return inMemoryPlaces
        }
        
        let prefixResults: [FavoritePlaceModel] = favoritesTrie.findWordsWithPrefix(prefix: word)
            .compactMap { uniqueID in
                FavoritePlaceModel(from: uniqueID)
            }
        let targetResults: Set<FavoritePlaceModel> = Set(prefixResults)
        
        return favoritesContainer.intersection(targetResults)
            .map { PlaceModel(from: $0) }
    }
    
    private func loadFavorites() throws {
        let favoritePlaces = try placesDB.read(
            sortBy: SortDescriptor<PlaceEntity>(\.name), SortDescriptor<PlaceEntity>(\.country)
        )
        .map { FavoritePlaceModel(from: $0) }
        
        let favoritesContainer = Set(favoritePlaces)
        
        for favoriteModel in favoritesContainer {
            favoritesTrie.insert(word: favoriteModel.uniqueID)
        }
                
        self.favoritesContainer = favoritesContainer
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
            placeModel.isFavorite = favoritesContainer.contains(favoriteModel)
            placeModels.append(placeModel)
        }
                
        self.inMemoryPlaces = placeModels.sorted { leftModel, rightModel in
            leftModel.sortID < rightModel.sortID
        }
    }
}

