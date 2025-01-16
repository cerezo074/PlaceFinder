//
//  SplashScreenViewModel.swift
//  PlaceFinder
//
//  Created by Eli Pacheco Hoyos on 30/12/24.
//

import Foundation

class SplashScreenViewModel: ObservableObject {
    typealias DomainDependencies = PlacesServices

    @Published
    var isAnimating: Bool = false
    
    private let domainDependencies: DomainDependencies
    private let didFinishLoading: VoidClousure
    let title = "Place Finder..."
    
    init(domainDependencies: DomainDependencies, didFinishLoading: @escaping VoidClousure) {
        self.domainDependencies = domainDependencies
        self.didFinishLoading = didFinishLoading
    }
    
    func viewDidAppear() async {
        do {
            try await domainDependencies.loadData()
        } catch {
            print("Error loading data: \(error)")
        }
        
        await callOnMainThread { [weak self] in
            self?.didFinishLoading()
            self?.isAnimating = false
        }
    }
}
