//
//  SwiftUIPreview.swift
//  PlaceFinder
//
//  Created by Eli Pacheco Hoyos on 30/12/24.
//

struct EmptyFactory {
    
    static let emptyListPlaces: PlacesServices = EmptyFactory.EmptyListPlaces()
    
    struct EmptyListPlaces: PlacesServices {
        func loadData() async {
            
        }
        
        func getAllPlaces() async throws -> [PlaceModel] {
            []
        }
    }
    
}
