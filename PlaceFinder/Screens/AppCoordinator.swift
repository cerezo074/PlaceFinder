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
    private let appDomains: AppDomains
    private let appServices: AppServices
    
    init(
        appDomains: AppDomains? = nil,
        appServices: AppServices? = nil
    ) {
        let appServices = appServices ?? PlaceFinderServices()
        let appDomains = appDomains ?? PlaceFinderDomains(
            listPlaces: PlacesController(repository: appServices.listPlacesDataServices)
        )
        self.appServices = appServices
        self.appDomains = appDomains
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
