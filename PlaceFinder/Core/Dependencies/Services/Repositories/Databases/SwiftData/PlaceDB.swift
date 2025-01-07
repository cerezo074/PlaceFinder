//
//  PlaceDB.swift
//  PlaceFinder
//
//  Created by Eli Pacheco Hoyos on 7/01/25.
//

import SwiftData

final class PlaceDB: SwiftDatabase {
    
    typealias T = PlaceEntity
    
    let container: ModelContainer
    
    /// Use an in-memory store to store non-persistent data when unit testing
    ///
    init(useInMemoryStore: Bool = false) throws {
        let configuration = ModelConfiguration(for: PlaceEntity.self, isStoredInMemoryOnly: useInMemoryStore)
        container = try ModelContainer(for: PlaceEntity.self, configurations: configuration)
    }
}
