//
//  PlaceValidatorProvider.swift
//  PlaceFinder
//
//  Created by Eli Pacheco Hoyos on 8/01/25.
//

import CoreLocation

protocol PlaceValidatorProvider {
    var placeValidatorProvider: PlaceValidatorServices { get }
}

protocol PlaceValidatorServices: AnyObject {
    func isLocationValid(lat: Double, lng: Double) async throws
}

protocol CLGeocoderInterface {
    func reverseGeocodeLocation(_ location: CLLocation) async throws -> [CLPlacemark]
}

extension CLGeocoder: CLGeocoderInterface {
    
}

class GeoCodeValidator: PlaceValidatorServices {
        
    enum LocationError: Error, LocalizedError {
        case invalidCoordinate
        case unknownLocation
        
        var errorDescription: String? {
            switch self {
            case .invalidCoordinate: return "Invalid coordinate."
            case .unknownLocation: return "No placemark found at this coordinate."
            }
        }
    }
    
    private let geocoder: CLGeocoderInterface
    
    init(geocoder: CLGeocoderInterface = CLGeocoder()) {
        self.geocoder = geocoder
    }
    
    func isLocationValid(lat: Double, lng: Double) async throws {
        let locationCoordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        
        if !isValidCoordinate(locationCoordinate) {
            throw LocationError.invalidCoordinate
        }
        
        let clLocation = CLLocation(latitude: locationCoordinate.latitude,
                                    longitude: locationCoordinate.longitude)
        let placemarks = try await geocoder.reverseGeocodeLocation(clLocation)
        
        if placemarks.isEmpty {
            throw LocationError.unknownLocation
        }
    }
    
    private func isValidCoordinate(_ coordinate: CLLocationCoordinate2D) -> Bool {
        guard !(coordinate.latitude == 0 && coordinate.longitude == 0),
              abs(coordinate.latitude) <= 90, abs(coordinate.longitude) <= 180 else {
            return false
        }
        
        return true
    }
}
