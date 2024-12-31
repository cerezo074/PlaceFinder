//
//  SplashScreenViewModel.swift
//  PlaceFinder
//
//  Created by Eli Pacheco Hoyos on 30/12/24.
//

import Foundation

class SplashScreenViewModel: ObservableObject {
    typealias DomainDependencies = ListPlaces

    @Published
    var isAnimating: Bool = false
    
    private let domainDependencies: DomainDependencies
    private let didFinishLoading: VoidClousure
    
    init(domainDependencies: DomainDependencies, didFinishLoading: @escaping VoidClousure) {
        self.domainDependencies = domainDependencies
        self.didFinishLoading = didFinishLoading
    }
    
    func viewDidAppear() async {
        await domainDependencies.loadData()
        await callOnMainThread { [weak self] in
            self?.didFinishLoading()
            self?.isAnimating = false
        }
    }
}
