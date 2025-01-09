//
//  ModelIDs.swift
//  PlaceFinder
//
//  Created by Eli Pacheco Hoyos on 9/01/25.
//


protocol ModelIDs {
    var country: String { get }
    var name: String { get }
    var coordinate: CoordinateModel { get }
}

extension ModelIDs {
    var uniqueID: String {
        "\(sortID),\(coordinate.latitude),\(coordinate.longitude)".lowercased()
    }
    
    var sortID: String {
        "\(name),\(country)".lowercased()
    }
}