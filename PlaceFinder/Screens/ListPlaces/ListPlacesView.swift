//
//  ListPlacesView.swift
//  PlaceFinder
//
//  Created by Eli Pacheco Hoyos on 30/12/24.
//
import SwiftUI

struct ListPlacesView: View {
    @StateObject private var viewModel: ListPlacesViewModel
    
    init(domainDependencies: ListPlacesViewModel.DomainDependencies) {
        _viewModel = .init(wrappedValue: .init(domainDependencies: domainDependencies))
    }

    @Environment(\.horizontalSizeClass)
    var horizontalSizeClass

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
    
    private func displayCountries(with countries: [String]) -> some View {
        Group {
            if horizontalSizeClass == .compact {
                MasterView(items: countries, selectedItem: $viewModel.selectedItem)
                        .navigationTitle("Items")
            } else {
                HStack {
                    MasterView(items: countries, selectedItem: $viewModel.selectedItem)
                        .frame(maxWidth: 300)
                        .background(Color(UIColor.systemGroupedBackground))
                    Divider()
                    DetailView(selectedItem: viewModel.selectedItem)
                        .frame(maxWidth: .infinity)
                        .background(Color(UIColor.systemBackground))
                }
                .navigationTitle("Master-Detail")
            }
        }
    }
}

struct MasterView: View {
    let items: [String]
    @Binding var selectedItem: String?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(items, id: \.self) { item in
                    Text(item)
                        .padding()
                        .background(selectedItem == item ? Color.blue.opacity(0.2) : Color.clear)
                        .cornerRadius(8)
                        .onTapGesture {
                            selectedItem = item
                        }
                }
            }
            .padding()
        }
    }
}

struct DetailView: View {
    let selectedItem: String?

    var body: some View {
        ScrollView {
            VStack {
                if let selectedItem = selectedItem {
                    Text("Detail for \(selectedItem)")
                        .font(.largeTitle)
                        .padding()
                } else {
                    Text("Select an item from the list")
                        .font(.title)
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
