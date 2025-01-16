//
//  ListPlacesRepositoryTests.swift
//  PlaceFinderTests
//
//  Created by Eli Pacheco Hoyos on 9/01/25.
//

import Testing
import Foundation
@testable import PlaceFinder

struct ListPlacesRepositoryTests {
    
    private let networkProviderMock = NetworkProviderMock<[PlaceDTO]>()
    private let favoritePlacesDBMock = PlacesDBMock()
    
    private lazy var repository: ListPlacesRepository = {
        ListPlacesRepository(
            networkServices: networkProviderMock,
            placesDB: favoritePlacesDBMock
        )
    }()

    @Test("Depedencies do not fail when they are called")
    mutating func loadAllPlaces_finishSuccessfully() async throws {
        try await repository.loadAllPlaces()
    }
    
    @Test("Favorites Database throws an exception when reading")
    mutating func loadAllPlaces_failsWithDatabaseException() async throws {
        favoritePlacesDBMock.shouldTriggerErrorOnRead = true
        
        await #expect {
            try await repository.loadAllPlaces()
        } throws: { error in
            guard let dbError = error as? PlacesDBMock.Errors else {
                return false
            }
            return dbError == .conectionError
        }
    }
    
    @Test("When data was loaded prevoiusly, fetchAllPlaces should return it")
    mutating func fetchAllPlaces_shouldReturnInMemoryData() async throws {
        networkProviderMock.data = .all
        try await repository.loadAllPlaces()
        
        let results = try await repository.fetchAllPlaces()
        
        #expect(results == .allSortedBySortID)
    }
    
    @Test("When data was not loaded prevoiusly, fetchAllPlaces hits network and returns it")
    mutating func fetchAllPlaces_shouldReturnFreshData() async throws {
        networkProviderMock.data = .all
        
        let results = try await repository.fetchAllPlaces()
        
        #expect(results == .allSortedBySortID)
    }
    
    @Test("When data is missing we hit network, but a network error occurs (e.g. no internet)")
    mutating func fetchAllPlaces_shouldFailWithError() async throws {
        networkProviderMock.data = .all
        networkProviderMock.shouldTriggerErrorOnRead = true

        await #expect(throws: URLError.self) {
            try await repository.fetchAllPlaces()
        }
    }
    
    @Test("Marking a place as isFavorite should persist it in DB after user sees the place list.")
    mutating func update_whenPlaceIsFavorite_shouldSaveInDB() async throws {
        networkProviderMock.data = .all
        try await repository.loadAllPlaces()

        try repository.update(place: .bogotaAsFavorite)
        
        let savedFavorite = try #require(favoritePlacesDBMock.inMemoryData.first)
        let savedModel = try await #require(repository.fetchAllPlaces().first)
        #expect(savedFavorite.id == PlaceEntity.bogota.id)
        #expect(savedModel.uniqueID == PlaceModel.bogotaAsFavorite.uniqueID)
        #expect(savedModel.isFavorite)
    }
    
    @Test("Should remove a place from DB when marked as not favorite")
    mutating func update_whenPlaceIsNotFavorite_shouldRemoveItFromDB() async throws {
        networkProviderMock.data = .all
        favoritePlacesDBMock.inMemoryData = [.bogota]
        try await repository.loadAllPlaces()

        try repository.update(place: .bogota)
        
        #expect(favoritePlacesDBMock.inMemoryData.first == nil)
        let savedModel = try await #require(repository.fetchAllPlaces().first)
        #expect(savedModel.uniqueID == PlaceModel.bogotaAsFavorite.uniqueID)
        #expect(!savedModel.isFavorite)
    }
    
    @Test("Should return all places when search word is empty")
    mutating func getFavoritesPlaces_whenWordIsEmpty_returnsAllPlaces() async throws {
        networkProviderMock.data = .all
        try await repository.loadAllPlaces()
        
        let results = repository.getFavoritesPlaces(by: "")
        
        #expect(results == .allSortedBySortID)
    }
    
    @Test("Should return matching places when valid word is provided")
    mutating func getFavoritesPlaces_whenWordIsValid_returnsMatches() async throws {
        networkProviderMock.data = .all
        favoritePlacesDBMock.inMemoryData = [.bogota, .buenosAires]
        try await repository.loadAllPlaces()
        
        let results = repository.getFavoritesPlaces(by: "B")
        
        #expect(results == .BPlacesSortedBySortID)
    }
    
    @Test("Should return one matching place with improved precision for more specific search")
    mutating func getFavoritesPlaces_ForPreciseSearch_returnsOneMatch() async throws {
        networkProviderMock.data = .all
        favoritePlacesDBMock.inMemoryData = [.bogota, .buenosAires]
        try await repository.loadAllPlaces()
        
        let results = repository.getFavoritesPlaces(by: "Bo")
        
        #expect(results == [.bogotaAsFavorite])
    }
    
    @Test("Should distinguish case-sensitive places when similar names exist")
    mutating func getFavoritesPlaces_withCaseSensitiveSearch_returnsUppercasedMatch() async throws {
        networkProviderMock.data = .all
        favoritePlacesDBMock.inMemoryData = [.bogota, .bogotaUppercased]
        try await repository.loadAllPlaces()
        
        let results = repository.getFavoritesPlaces(by: "BO")
        
        #expect(results == [.bogotaUppercased])
    }
}
