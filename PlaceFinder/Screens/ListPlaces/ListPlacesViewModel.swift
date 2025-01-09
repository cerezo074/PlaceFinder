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
        await fetchPlaces()

        guard !didLoadView else { return }
        didLoadView = true
        
        listenToSearchTextChanges()
    }
    
    func reloadContent() async {
        await callOnMainThread { [weak self] in
            self?.isLoadingSearchResults = false
            self?.searchText = ""
        }
        
        await fetchPlaces()
    }
    
    func toggleFavorite(on locationViewModel: LocationViewModel) async {
        var model = PlaceModel(from: locationViewModel)
        model.isFavorite.toggle()
        
        do {
            try placesProvider.update(place: model)
            
            await callOnMainThread { [weak locationViewModel] in
                locationViewModel?.isFavorite.toggle()
            }
        } catch {
            // TODO: Show visual feedback to the user.
            print("Error updating place: \(error)")
        }
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
            let countries = try await placesProvider.getAllPlaces()
                .enumerated()
                .map { (index, value) in
                LocationViewModel(
                    index: index,
                    place: value,
                    domainDependencies: placesValidator
                )
            }
            
            await callOnMainThread { [weak self] in
                self?.listViewState = .showCountries(locations: countries)
            }
        } catch {
            print("error: \(error.localizedDescription)")
            await callOnMainThread { [weak self] in
                self?.listViewState = .retry
            }
        }
    }
    
    private func applyFilter(with text: String) {
        Task {
            await displaySearchLoader(!text.isEmpty, show: true)
            
            do {
                let favoriteLocations = try placesProvider.filterPlaces(by: text)
                    .enumerated()
                    .map { index, value in
                        LocationViewModel(
                            index: index,
                            place: value,
                            domainDependencies: placesValidator
                        )
                    }
                
                await callOnMainThread { [weak self] in
                    self?.listViewState = .showCountries(locations: favoriteLocations)
                }
            } catch {
                print("error: \(error.localizedDescription)")
                await callOnMainThread { [weak self] in
                    self?.listViewState = .retry
                }
            }
            
            await displaySearchLoader(!text.isEmpty, show: false)
        }
    }
    
    private func displaySearchLoader(_ isEnabled: Bool, show: Bool) async {
        guard isEnabled else { return }
        await callOnMainThread { [weak self] in
            self?.isLoadingSearchResults = show
        }
    }
}
