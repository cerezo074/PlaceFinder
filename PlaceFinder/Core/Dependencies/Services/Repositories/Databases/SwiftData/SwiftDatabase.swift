//
//  SwiftDatabase.swift
//  PlaceFinder
//
//  Created by Eli Pacheco Hoyos on 7/01/25.
//


import Foundation
import SwiftData

protocol SwiftDatabase<T>: Database {
    associatedtype T = PersistentModel
    var container: ModelContainer { get }
}

extension SwiftDatabase {
    
    func create<T: PersistentModel>(_ items: [T]) throws {
        let batchSize = 1000
        let context = ModelContext(container)
        
        for (index, item) in items.enumerated() {
            context.insert(item)
            // Save the context after every batchSize insertions
            if (index + 1) % batchSize == 0 {
                try context.save()
            }
        }
        
        // Save any remaining items that didn't fill a complete batch
        if items.count % batchSize != 0 {
            try context.save()
        }
    }
    
    func create<T: PersistentModel>(_ item: T) throws {
        let context = ModelContext(container)
        context.insert(item)
        try context.save()
    }
    
    func read<T: PersistentModel>(sortBy sortDescriptors: SortDescriptor<T>...) throws -> [T] {
        let context = ModelContext(container)
        let fetchDescriptor = FetchDescriptor<T>(
            sortBy: sortDescriptors
        )
        return try context.fetch(fetchDescriptor)
    }
    
    func update<T: PersistentModel>(_ item: T) throws {
        let context = ModelContext(container)
        context.insert(item)
        try context.save()
    }
    
    func delete<T: PersistentModel>(_ item: T) throws {
        let context = ModelContext(container)
        try context.delete(model: T.self)
        try context.save()
    }
}
