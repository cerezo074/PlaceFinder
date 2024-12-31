//
//  ListPlacesProvider.swift
//  PlaceFinder
//
//  Created by Eli Pacheco Hoyos on 30/12/24.
//

import Foundation

protocol ListPlacesProvider {
    var listPlaces: ListPlaces { get }
}

protocol ListPlaces {
    func loadData() async
    func getAllPlaces() async throws -> [String]
}

class PlacesController: ListPlaces {
    private var data: [String] = []

    func loadData() async {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        data = ["Colombia", "Peru", "Argentina"]
    }
    
    func getAllPlaces() async throws -> [String] {
        return data
    }
}

