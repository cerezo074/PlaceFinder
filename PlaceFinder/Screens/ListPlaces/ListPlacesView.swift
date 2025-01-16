//
//  ListPlacesView.swift
//  PlaceFinder
//
//  Created by Eli Pacheco Hoyos on 30/12/24.
//
import SwiftUI

struct ListPlacesView: View {
    
    @StateObject
    private var viewModel: ListPlacesViewModel
    @State
    private var isLandscape: Bool
    private let appCoordinator: AppCoordinator
    
    init(
        placesProvider: PlacesServices,
        placesValidator: PlaceValidatorServices,
        appCoordinator: AppCoordinator
    ) {
        _viewModel = .init(
            wrappedValue: .init(
                placesProvider: placesProvider,
                placesValidator: placesValidator
            )
        )
        isLandscape = UIDevice.current.orientation.isLandscape
        self.appCoordinator = appCoordinator
    }

    var body: some View {
        switch viewModel.listViewState {
        case .loading:
            ProgressView(viewModel.loadingText)
                .task {
                    await viewModel.viewDidAppear()
                }
        case .retry:
            retryButton
        case .showCountries(let list):
            displayCountries(with: list)
                .detectLandscape($isLandscape)
                .disabled(viewModel.isLoadingSearchResults)
        }
    }
    
    private var retryButton: some View {
        VStack {
            Text(viewModel.errorLoadingCountriesText)
                .fontWeight(.semibold)
                .font(.headline)
                .padding(.bottom, Constants.bottomPadding)
                .multilineTextAlignment(.center)
            Button {
                Task {
                    await viewModel.viewDidAppear()
                }
            } label: {
                Text(viewModel.retryText)
                    .font(.callout)
                    .padding()
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(Constants.cornerRadius)
            }
        }
    }
    
    private var emptyCountriesView: some View {
        VStack {
            Text(viewModel.noCountriesFoundText)
                .fontWeight(.semibold)
                .font(.headline)
                .padding(.bottom, Constants.bottomPadding)
                .multilineTextAlignment(.center)
            Button {
                Task {
                    await viewModel.reloadContent()
                }
            } label: {
                Text(viewModel.resetText)
                    .font(.callout)
                    .padding()
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(Constants.cornerRadius)
            }
        }
    }
    
    @ViewBuilder
    private var landscapeMapView: some View {
        if let selectedItem = viewModel.selectedItem {
            LocationMapView(
                selectedItem: selectedItem,
                refreshCameraManually: true,
                backButtonAction: nil
            )
            .frame(maxWidth: .infinity)
            .background(Color(UIColor.systemBackground))
        } else {
            Text(viewModel.selectItemText)
                .font(.title)
                .foregroundColor(.gray)
                .padding()
        }
    }
    
    private func makeDefaultCountriesView(with countries: [LocationViewModel]) -> some View {
        VStack {
            if isLandscape {
                HStack {
                    makeMenuView(with: countries)
                    .frame(maxWidth: Constants.menuMaxWidth)
                    .background(Color(.systemGroupedBackground))
                    landscapeMapView
                }
                .navigationTitle(viewModel.masterDetailTitle)
            } else {
                makeMenuView(with: countries)
                .onReceive(viewModel.$selectedItem) { selectedItem in
                    guard let selectedItem else { return }
                    appCoordinator.baseNavigationPath.append(selectedItem)
                }
                .navigationTitle(viewModel.itemsTitle)
            }
        }.onChange(of: isLandscape, { oldValue, newValue in
            if newValue, !appCoordinator.baseNavigationPath.isEmpty {
                appCoordinator.baseNavigationPath = .init()
            }
        })
        .navigationDestination(for: LocationViewModel.self) { selectedItem in
            LocationMapView(selectedItem: selectedItem, refreshCameraManually: false) {
                viewModel.selectedItem = nil
                appCoordinator.baseNavigationPath.removeLast()
            }
        }
    }
    
    @ViewBuilder
    private func displayCountries(with countries: [LocationViewModel]) -> some View {
        if countries.isEmpty {
            emptyCountriesView
        } else {
            makeDefaultCountriesView(with: countries)
        }
    }
    
    private func makeMenuView(with countries: [LocationViewModel]) -> some View {
        LocationMenuView(
            selectedItem: $viewModel.selectedItem,
            searchText: $viewModel.searchText,
            placeholder: viewModel.searchPlaceholder,
            isLoading: viewModel.isLoadingSearchResults,
            items: countries,
            toggleFavoriteItem: { [weak viewModel] locationViewModel in
                guard let viewModel else { return }
                
                Task {
                    await viewModel.toggleFavorite(on: locationViewModel)
                }
            }
        )
    }
    
    // MARK: - Constants

    enum Constants {        
        static let bottomPadding: CGFloat = 20
        static let cornerRadius: CGFloat = 10
        static let menuMaxWidth: CGFloat = 300
    }
    
}
