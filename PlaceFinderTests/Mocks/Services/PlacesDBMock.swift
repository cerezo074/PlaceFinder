//
//  PlacesDBMock.swift
//  PlaceFinder
//
//  Created by Eli Pacheco Hoyos on 9/01/25.
//

import Foundation
@testable import PlaceFinder

class PlacesDBMock: Database {
    
    typealias T = PlaceEntity

    enum Errors: Error, LocalizedError {
        case notFound
        case conectionError
        
        var errorDescription: String? {
            switch self {
            case .notFound:
                return "Item Not Found"
            case .conectionError:
                return "A Connection could not be established with the Database"
            }
        }
    }
    
    var inMemoryData: [PlaceEntity] = []
    var shouldTriggerErrorOnRead: Bool = false

    func create(_ item: PlaceEntity) throws {
        inMemoryData.append(item)
    }
    
    func create(_ items: [PlaceEntity]) throws {
        inMemoryData.append(contentsOf: items)
    }
    
    func read(sortBy sortDescriptors: [SortDescriptor<PlaceEntity>]) throws -> [PlaceEntity] {
        if shouldTriggerErrorOnRead {
            throw Errors.conectionError
        }
        
        return inMemoryData
    }
    
    func update(_ item: PlaceEntity) throws {
        guard let itemIndex = inMemoryData.firstIndex(of: item) else {
            try create(item)
            return
        }
        
        inMemoryData[itemIndex] = item
    }
    
    func delete(_ item: PlaceEntity) throws {
        guard let itemIndex = inMemoryData.firstIndex(
            where: { $0.id == item.id }
        ) else {
            throw Errors.notFound
        }
        
        inMemoryData.remove(at: itemIndex)
    }
    
}
