//
//  SwiftUIPreview.swift
//  PlaceFinder
//
//  Created by Eli Pacheco Hoyos on 30/12/24.
//

struct EmptyFactory {
    
    static let emptyListPlaces: ListPlaces = EmptyFactory.EmptyListPlaces()
    
    struct EmptyListPlaces: ListPlaces {
        func loadData() async {
            
        }
        
        func getAllPlaces() async throws -> [String] {
            []
        }
    }
    
}
