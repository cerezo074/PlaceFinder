//
//  Database.swift
//  PlaceFinder
//
//  Created by Eli Pacheco Hoyos on 7/01/25.
//

import Foundation

protocol Database<T> {
    associatedtype T
    func create(_ item: T) throws
    func create(_ items: [T]) throws
    func read(sortBy sortDescriptors: SortDescriptor<T>...) async throws -> [T]
    func update(_ item: T) throws
    func delete(_ item: T) throws
}
