//
//  LocationViewModel.swift
//  PlaceFinder
//
//  Created by Eli Pacheco Hoyos on 7/01/25.
//

import SwiftUI
import MapKit

class LocationViewModel: ObservableObject, Identifiable, Hashable {
    typealias DomainDependencies = PlaceValidatorServices

    enum LocationState: Hashable {
        case loading
        case success
        case failure(String)
    }
    
    @Published
    var locationState: LocationState
    @Published
    var isFavorite: Bool
    let index: Int
    let name: String
    let country: String
    let latitude: Double
    let longitude: Double
        
    // MARK: - Computed
    
    var id: Int {
        index
    }
    
    var detailTitle: String {
        name
    }
    
    var menuTitle: String {
        "\(index + 1). \(name), \(country)"
    }
    
    var locationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    private let domainDependencies: DomainDependencies
    
    init(
        index: Int,
        name: String,
        country: String,
        latitude: Double,
        longitude: Double,
        isFavorite: Bool,
        domainDependencies: DomainDependencies
    ) {
        self.index = index
        self.name = name
        self.country = country
        self.latitude = latitude
        self.longitude = longitude
        self.isFavorite = isFavorite
        self.locationState = .loading
        self.domainDependencies = domainDependencies
    }
    
    convenience init(
        index: Int,
        place: PlaceModel,
        domainDependencies: DomainDependencies
    ) {        
        self.init(
            index: index,
            name: place.name,
            country: place.country,
            latitude: place.coordinate.lat,
            longitude: place.coordinate.lat,
            isFavorite: place.isFavorite,
            domainDependencies: domainDependencies
        )
    }

    func validateLocation() async {
        do {
            try await domainDependencies.isLocationValid(lat: latitude, lng: longitude)
            
            await callOnMainThread { [weak self] in
                self?.locationState = .success
            }
        } catch {            
            await callOnMainThread { [weak self] in
                self?.locationState = .failure("There is an error with the current location: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Hashable
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: LocationViewModel, rhs: LocationViewModel) -> Bool {
        lhs.id == rhs.id
    }
}
