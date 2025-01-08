//
//  ListPlacesViewModel.swift
//  PlaceFinder
//
//  Created by Eli Pacheco Hoyos on 30/12/24.
//
import Foundation

class ListPlacesViewModel: ObservableObject {
    
    enum ViewState {
        case loading
        case retry
        case showCountries(locations: [LocationViewModel])
    }
    
    @Published
    private(set) var viewState: ViewState
    @Published
    var selectedItem: LocationViewModel?
    private let placesProvider: PlacesServices
    private let placesValidator: PlaceValidatorServices
    
    init(
        placesProvider: PlacesServices,
        placesValidator: PlaceValidatorServices
    ) {
        self.placesProvider = placesProvider
        self.placesValidator = placesValidator
        self.viewState = .loading
    }
    
    func viewDidAppear() async {
        await callOnMainThread { [weak self] in
            self?.viewState = .loading
        }
        
        do {
            let countries = try await placesProvider.getAllPlaces().enumerated().map { (index, value) in
                LocationViewModel(
                    index: index,
                    name: value.name,
                    country: value.country,
                    latitude: value.coordinate.lat,
                    longitude: value.coordinate.lon,
                    domainDependencies: placesValidator
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
