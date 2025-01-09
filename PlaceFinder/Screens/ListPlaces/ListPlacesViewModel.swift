//
//  ListPlacesViewModel.swift
//  PlaceFinder
//
//  Created by Eli Pacheco Hoyos on 30/12/24.
//

import Foundation
import Combine

class ListPlacesViewModel: ObservableObject {
    
    enum ListViewState {
        case loading
        case retry
        case showCountries(locations: [LocationViewModel])
    }
    
    @Published
    private(set) var listViewState: ListViewState
    @Published
    var selectedItem: LocationViewModel?
    @Published
    var searchText: String
    @Published
    var isLoadingSearchResults: Bool
    let searchPlaceholder: String
    private var didLoadView: Bool
    private var subscriptions: Set<AnyCancellable>
    private let placesProvider: PlacesServices
    private let placesValidator: PlaceValidatorServices
    
    init(
        placesProvider: PlacesServices,
        placesValidator: PlaceValidatorServices
    ) {
        self.placesProvider = placesProvider
        self.placesValidator = placesValidator
        self.listViewState = .loading
        self.searchText = ""
        self.searchPlaceholder = "Type to show your favorite places"
        self.subscriptions = []
        self.didLoadView = false
        self.isLoadingSearchResults = false
    }
    
    func viewDidAppear() async {
        guard !didLoadView else { return }
        didLoadView = true
        
        listenToSearchTextChanges()
        await fetchPlaces()
    }
    
    private func listenToSearchTextChanges() {
        $searchText
            .dropFirst()
            .removeDuplicates()
            .debounce(for: .seconds(3), scheduler: DispatchQueue.main)
            .sink { [weak self] searchText in
                self?.applyFilter(with: searchText)
            }
            .store(in: &subscriptions)
    }
    
    private func fetchPlaces() async {
        await callOnMainThread { [weak self] in
            self?.listViewState = .loading
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
                self?.listViewState = .showCountries(locations: countries)
            }
        } catch {
            await callOnMainThread { [weak self] in
                self?.listViewState = .retry
            }
        }
    }
    
    private func applyFilter(with text: String) {
        Task {
            await callOnMainThread { [weak self] in
                self?.isLoadingSearchResults = true
            }
            
            try? await Task.sleep(for: .milliseconds(5000))
            
            await callOnMainThread { [weak self] in
                self?.isLoadingSearchResults = false
            }
        }
    }
}
