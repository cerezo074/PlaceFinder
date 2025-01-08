//
//  ListPlacesViewModel.swift
//  PlaceFinder
//
//  Created by Eli Pacheco Hoyos on 30/12/24.
//
import Foundation

class ListPlacesViewModel: ObservableObject {
    typealias DomainDependencies = ListPlaces
    
    enum ViewState {
        case loading
        case retry
        case showCountries(locations: [LocationViewModel])
    }
    
    @Published
    private(set) var viewState: ViewState
    @Published
    var selectedItem: LocationViewModel?

    private let domainDependencies: DomainDependencies
    
    init(domainDependencies: DomainDependencies) {
        self.domainDependencies = domainDependencies
        self.viewState = .loading
    }
    
    func viewDidAppear() async {
        await callOnMainThread { [weak self] in
            self?.viewState = .loading
        }
        
        do {
            let countries = try await domainDependencies.getAllPlaces().enumerated().map { (index, value) in
                LocationViewModel(
                    index: index,
                    name: value.name,
                    country: value.country,
                    latitude: value.coordinate.lat,
                    longitude: value.coordinate.lon
                )
            }
            
            await callOnMainThread { [weak self] in
                self?.viewState = .showCountries(locations: countries)
            }
        } catch {
            await callOnMainThread { [weak self] in
                self?.viewState = .retry
            }
        }
    }
}
