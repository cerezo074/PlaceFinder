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
    let placesDB: any SwiftDatabase<PlaceEntity>
    
    init(
        networkServices: NetworkServices? = nil,
        placesDB: (any SwiftDatabase<PlaceEntity>)? = nil,
        listPlacesDataServices: ListPlacesDataServices? = nil
    ) throws {
        let networkServices = networkServices ?? NetworkController()
        let placesDB = if let placesDB { placesDB } else { try PlaceDB() }
        self.listPlacesDataServices = listPlacesDataServices ??
        ListPlacesRepository(networkServices: networkServices, placesDB: placesDB)
        self.networkServices = networkServices
        self.placesDB = placesDB
    }
}
