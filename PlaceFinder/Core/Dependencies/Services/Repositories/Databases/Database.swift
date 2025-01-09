//
//  Database.swift
//  PlaceFinder
//
//  Created by Eli Pacheco Hoyos on 7/01/25.
//

import Foundation

// For more information, https://blog.jacobstechtavern.com/p/swiftdata-outside-swiftui

protocol Database<T> {
    associatedtype T
    func create(_ item: T) throws
    func create(_ items: [T]) throws
    func read(sortBy sortDescriptors: [SortDescriptor<T>]) throws -> [T]
    func update(_ item: T) throws
    func delete(_ item: T) throws
}

protocol PlacesDataProvider {
    var placesDataProvider: any PlaceDataServices { get }
}

typealias PlaceDataServices = Database<PlaceEntity>
