//
//  AppDomains.swift
//  PlaceFinder
//
//  Created by Eli Pacheco Hoyos on 30/12/24.
//

typealias AppDomains = PlacesProvider &
                       PlaceValidatorProvider

class PlaceFinderDomains: AppDomains {
    var placesProvider: PlacesServices {
        placesController
    }
    
    var placeValidatorProvider: PlaceValidatorServices {
        placesController
    }
    
    private let placesController: PlacesServices & PlaceValidatorServices
    
    init(appServices: AppServices) {
        let repository = ListPlacesRepository.init(
            networkServices: appServices.networkProvider,
            placesDB: appServices.placesDataProvider
        )
        
        self.placesController = PlacesController(
            repository: repository,
            validator: appServices.placeValidatorProvider
        )
    }
}
