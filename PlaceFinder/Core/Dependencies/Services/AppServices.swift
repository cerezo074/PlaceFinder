//
//  AppServices.swift
//  PlaceFinder
//
//  Created by Eli Pacheco Hoyos on 31/12/24.
//

typealias AppServices = NetworkProvider &
                        PlacesDataProvider &
                        PlaceValidatorProvider

class PlaceFinderServices: AppServices {
    let networkProvider: NetworkServices
    let placesDataProvider: any PlaceDataServices
    let placeValidatorProvider: PlaceValidatorServices
    
    init(
        networkServices: NetworkServices? = nil,
        placesDB: (any Database<PlaceEntity>)? = nil,
        placeValidatorServices: PlaceValidatorServices? = nil
    ) {
        self.networkProvider = networkServices ?? NetworkController()
        self.placeValidatorProvider = placeValidatorServices ?? GeoCodeValidator()
        self.placesDataProvider = if let placesDB {
            placesDB
        } else {
            (try? PlaceDB() as any Database<PlaceEntity>) ?? EmptyDatabase()
        }
    }
}

