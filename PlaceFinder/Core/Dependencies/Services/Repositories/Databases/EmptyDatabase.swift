//
//  EmptyDatabase.swift
//  PlaceFinder
//
//  Created by Eli Pacheco Hoyos on 8/01/25.
//

import Foundation

class EmptyDatabase: Database {
    
    typealias T = PlaceEntity
    
    init () {
        assertionFailure("Using EmptyDatabase is not recommended as fallback for release code")
    }
    
    func create(_ item: PlaceEntity) throws {
        
    }
    
    func create(_ items: [PlaceEntity]) throws {

    }
    
    func read(
        sortBy sortDescriptors: SortDescriptor<PlaceEntity>...
    ) throws -> [PlaceEntity] {
        return []
    }
    
    func update(_ item: PlaceEntity) throws {
        
    }
    
    func delete(_ item: PlaceEntity) throws {
        
    }
}
