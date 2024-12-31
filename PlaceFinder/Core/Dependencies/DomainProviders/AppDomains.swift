//
//  AppDomains.swift
//  PlaceFinder
//
//  Created by Eli Pacheco Hoyos on 30/12/24.
//

typealias AppDomains = ListPlacesProvider

class PlaceFinderDomains: AppDomains {
    let listPlaces: ListPlaces
    
    init(listPlaces: ListPlaces? = nil) {
        self.listPlaces = listPlaces ?? PlacesController()
    }
}
