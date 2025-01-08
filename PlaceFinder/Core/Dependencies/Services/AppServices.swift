//
//  AppServices.swift
//  PlaceFinder
//
//  Created by Eli Pacheco Hoyos on 31/12/24.
//

typealias AppServices = NetworkProvider & ListPlacesDataProvider

class PlaceFinderServices: AppServices {
    let networkServices: NetworkServices
    let listPlacesDataServices: ListPlacesDataServices
    let placesDB: any Database<PlaceEntity>
    
    init(
        networkServices: NetworkServices? = nil,
        placesDB: (any Database<PlaceEntity>)? = nil,
        listPlacesDataServices: ListPlacesDataServices? = nil
    ) {
        let networkServices = networkServices ?? NetworkController()
        let placesDB = if let placesDB {
            placesDB
        } else {
            (try? PlaceDB() as any Database<PlaceEntity>) ?? EmptyDatabase()
        }
        self.listPlacesDataServices = listPlacesDataServices ??
        ListPlacesRepository(networkServices: networkServices, placesDB: placesDB)
        self.networkServices = networkServices
        self.placesDB = placesDB
    }
}

