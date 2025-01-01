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

    init(
        networkServices: NetworkServices? = nil,
        listPlacesDataServices: ListPlacesDataServices? = nil
    ) {
        let networkServices = networkServices ?? NetworkController()
        self.listPlacesDataServices = listPlacesDataServices ?? ListPlacesRepository(networkServices: networkServices)
        self.networkServices = networkServices
    }
}
