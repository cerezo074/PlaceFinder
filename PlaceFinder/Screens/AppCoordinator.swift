//
//  AppCoordinator.swift
//  PlaceFinder
//
//  Created by Eli Pacheco Hoyos on 30/12/24.
//

import SwiftUI

class AppCoordinator: ObservableObject {
    
    enum AppState {
        case onStartup
        case home
    }
    
    /// This navigation path is used only for navigating when the app is fully loaded (home state)
    @Published
    var baseNavigationPath: NavigationPath
    @Published
    private(set) var appState: AppState
    private(set) var appDomains: AppDomains
    
    init(appDomains: AppDomains? = nil) {
        self.appDomains = appDomains ?? PlaceFinderDomains()
        self.baseNavigationPath = .init()
        self.appState = .onStartup
    }
    
    @ViewBuilder
    func makeView() -> some View {
        switch appState {
        case .onStartup:
            SplashScreenView(
                viewModel: .init(
                    domainDependencies: appDomains.listPlaces,
                    didFinishLoading: { [weak self] in
                        self?.appState = .home
                    }
                )
            )
        case .home:
            ListPlacesView(
                domainDependencies: appDomains.listPlaces,
                appCoordinator: self
            )
        }
    }
    
}
