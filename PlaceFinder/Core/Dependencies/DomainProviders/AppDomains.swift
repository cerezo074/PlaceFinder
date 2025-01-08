//
//  AppDomains.swift
//  PlaceFinder
//
//  Created by Eli Pacheco Hoyos on 30/12/24.
//

typealias AppDomains = ListPlacesProvider &
                       PlaceValidatorProvider

class PlaceFinderDomains: AppDomains {
    private let placesController: PlacesServices & PlaceValidatorServices
    
    var placesProvider: PlacesServices {
        placesController
    }
    
    var placeValidatorProvider: PlaceValidatorServices {
        placesController
    }
    
    init(placesController: PlacesServices & PlaceValidatorServices) {
        self.placesController = placesController
    }
}
