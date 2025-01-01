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
        case showCountries(list: [String])
    }
    
    @Published
    private(set) var viewState: ViewState
    @Published
    var selectedItem: String?

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
                "\(index). \(value.name), \(value.country)"
            }
            
            await callOnMainThread { [weak self] in
                self?.viewState = .showCountries(list: countries)
            }
        } catch {
            await callOnMainThread { [weak self] in
                self?.viewState = .retry
            }
        }
    }
}
