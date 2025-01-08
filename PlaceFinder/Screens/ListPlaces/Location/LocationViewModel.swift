//
//  LocationViewModel.swift
//  PlaceFinder
//
//  Created by Eli Pacheco Hoyos on 7/01/25.
//


import SwiftUI
import MapKit

class LocationViewModel: ObservableObject, Identifiable, Hashable {
    
    enum LocationState: Hashable {
        case loading
        case success
        case failure(String)
    }
    
    @Published
    var locationState: LocationState = .loading
    
    let index: Int
    let name: String
    let country: String
    let latitude: Double
    let longitude: Double
    
    var id: Int { index }
    
    // MARK: - Computed
    
    var detailTitle: String {
        name
    }
    
    var menuTitle: String {
        "\(index + 1). \(name), \(country)"
    }
    
    var locationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(index: Int,
         name: String,
         country: String,
         latitude: Double,
         longitude: Double
    ) {
        self.index = index
        self.name = name
        self.country = country
        self.latitude = latitude
        self.longitude = longitude
    }

    func validateLocation() async {
        if !isValidCoordinate(locationCoordinate) {
            await callOnMainThread { [weak self] in
                self?.locationState = .failure("Invalid or unknown location.")
            }
            
            return
        }
        
        let clLocation = CLLocation(latitude: locationCoordinate.latitude,
                                    longitude: locationCoordinate.longitude)
        let geocoder = CLGeocoder()

        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(clLocation)
            
            await callOnMainThread { [weak self] in
                if placemarks.isEmpty {
                    self?.locationState = .failure("No placemark found at this coordinate.")
                } else {
                    self?.locationState = .success
                }
            }
        } catch {            
            await callOnMainThread { [weak self] in
                self?.locationState = .failure("Geocoding failed: \(error.localizedDescription)")
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
    
    // MARK: - Private coordinate checker
    
    private func isValidCoordinate(_ coordinate: CLLocationCoordinate2D) -> Bool {
        guard !(coordinate.latitude == 0 && coordinate.longitude == 0),
              abs(coordinate.latitude) <= 90, abs(coordinate.longitude) <= 180 else {
            return false
        }
        
        return true
    }
}
