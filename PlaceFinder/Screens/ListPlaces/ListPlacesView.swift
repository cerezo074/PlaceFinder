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
        domainDependencies: ListPlacesViewModel.DomainDependencies,
        appCoordinator: AppCoordinator
    ) {
        _viewModel = .init(wrappedValue: .init(domainDependencies: domainDependencies))
        isLandscape = UIDevice.current.orientation.isLandscape
        self.appCoordinator = appCoordinator
    }

    var body: some View {
        switch viewModel.viewState {
        case .loading:
            ProgressView("Loading...")
                .task {
                    await viewModel.viewDidAppear()
                }
        case .retry:
            retryButton
        case .showCountries(let list):
            displayCountries(with: list)
                .detectLandscape($isLandscape)
        }
    }
    
    private var retryButton: some View {
        VStack {
            Text("Sorry there was an error loading the countries")
                .fontWeight(.semibold)
                .font(.headline)
                .padding(.bottom, 20)
                .multilineTextAlignment(.center)
            Button {
                Task {
                    await viewModel.viewDidAppear()
                }
            } label: {
                Text("Tap to retry")
                    .font(.callout)
                    .padding()
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
        }
    }
    
    private func displayCountries(with countries: [LocationViewModel]) -> some View {
        Group {
            if isLandscape {
                HStack {
                    LocationMenuView(
                        selectedItem: $viewModel.selectedItem,
                        items: countries
                    )
                    .frame(maxWidth: 300)
                    .background(Color(UIColor.systemGroupedBackground))
                    landscapeMapView
                }
                .navigationTitle("Master-Detail")
            } else {
                LocationMenuView(
                    selectedItem: $viewModel.selectedItem,
                    items: countries
                )
                .onReceive(viewModel.$selectedItem) { selectedItem in
                    guard let selectedItem else { return }
                    appCoordinator.baseNavigationPath.append(selectedItem)
                }
                .navigationTitle("Items")
            }
        }.onChange(of: isLandscape, { oldValue, newValue in
            if newValue, !appCoordinator.baseNavigationPath.isEmpty {
                appCoordinator.baseNavigationPath = .init()
            }
        })
        .navigationDestination(for: LocationViewModel.self) { selectedItem in
            LocationMapView(selectedItem: selectedItem) {
                viewModel.selectedItem = nil
                appCoordinator.baseNavigationPath.removeLast()
            }
        }
    }
    
    @ViewBuilder
    private var landscapeMapView: some View {
        if let selectedItem = viewModel.selectedItem {
            LocationMapView(
                selectedItem: selectedItem,
                backButtonAction: nil
            )
            .frame(maxWidth: .infinity)
            .background(Color(UIColor.systemBackground))
        } else {
            Text("Select an item from the list")
                .font(.title)
                .foregroundColor(.gray)
                .padding()
        }
    }
}
