//
//  AppServices.swift
//  PlaceFinder
//
//  Created by Eli Pacheco Hoyos on 31/12/24.
//

typealias AppServices = NetworkProvider &
                        ListPlacesDataProvider &
                        PlaceValidatorProvider

class PlaceFinderServices: AppServices {
    let networkProvider: NetworkServices
    let listPlacesDataProvider: ListPlacesDataServices
    let placeValidatorProvider: PlaceValidatorServices
    private let placesDB: any Database<PlaceEntity>
    
    init(
        networkServices: NetworkServices? = nil,
        placesDB: (any Database<PlaceEntity>)? = nil,
        listPlacesDataServices: ListPlacesDataServices? = nil,
        placeValidatorServices: PlaceValidatorServices? = nil
    ) {
        let networkServices = networkServices ?? NetworkController()
        let placesDB = if let placesDB {
            placesDB
        } else {
            (try? PlaceDB() as any Database<PlaceEntity>) ?? EmptyDatabase()
        }
        self.placesDB = placesDB
        self.placeValidatorProvider = placeValidatorServices ?? GeoCodeValidator()
        self.networkProvider = networkServices
        self.listPlacesDataProvider = listPlacesDataServices ??
        ListPlacesRepository(networkServices: networkServices, placesDB: placesDB)
    }
}

