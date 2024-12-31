//
//  PlaceFinderApp.swift
//  PlaceFinder
//
//  Created by Eli Pacheco Hoyos on 30/12/24.
//

import SwiftUI

@main
struct PlaceFinderApp: App {
    @StateObject private var mainCoordinator: AppCoordinator
    
    init() {
        _mainCoordinator = .init(wrappedValue: AppCoordinator())
    }
    
    var body: some Scene {
        WindowGroup {
            AppContentView(mainCoordinator: mainCoordinator)
        }
    }
}
