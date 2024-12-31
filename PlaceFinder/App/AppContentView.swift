//
//  AppContentView.swift
//  PlaceFinder
//
//  Created by Eli Pacheco Hoyos on 30/12/24.
//

import SwiftUI



struct AppContentView: View {
    @ObservedObject private var mainCoordinator: AppCoordinator
    
    init(mainCoordinator: AppCoordinator) {
        self.mainCoordinator = mainCoordinator
    }
    
    var body: some View {
        if mainCoordinator.appState == .home {
            NavigationStack(path: $mainCoordinator.baseNavigationPath) {
                mainCoordinator.makeView()
            }
        } else {
            mainCoordinator.makeView()
        }
    }
}


