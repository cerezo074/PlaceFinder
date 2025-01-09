//
//  LocationMenuView.swift
//  PlaceFinder
//
//  Created by Eli Pacheco Hoyos on 30/12/24.
//

import SwiftUI

struct LocationMenuView: View {
    @Binding
    var selectedItem: LocationViewModel?
    @Binding
    var searchText: String
    let placeholder: String
    let isLoading: Bool
    let items: [LocationViewModel]
    let toggleSelectedItem: (LocationViewModel) -> Void

    var body: some View {
        VStack {
            SearchBar(
                text: $searchText,
                isLoading: isLoading,
                placeholder: placeholder
            )
            ScrollView(showsIndicators: false) {
                LazyVStack(alignment: .leading) {
                    ForEach(items, id: \.self) {
                        makeItem($0)
                    }
                }
                .padding()
                .background(.green)
            }
        }
    }
    
    private func makeItem(_ item: LocationViewModel) -> some View {
        MenuRowItemView(viewModel: item, didTapItem: { viewModel in
            selectedItem = viewModel
        }, didTapFavorite: { viewModel in
            toggleSelectedItem(viewModel)
        })
        .background(
            selectedItem == item
            ? Color.yellow.opacity(0.6)
            : Color.clear
        )
    }
}

struct MenuRowItemView: View {
    @ObservedObject
    var viewModel: LocationViewModel
    var didTapItem: (LocationViewModel) -> Void
    var didTapFavorite: (LocationViewModel) -> Void
    
    var body: some View {
        HStack {
                Text(viewModel.menuTitle)
                    .padding()
                    .cornerRadius(8)
                    .onTapGesture {
                        didTapItem(viewModel)
                    }
                
                Spacer()
                
                Button(action: {
                    didTapFavorite(viewModel)
                }) {
                    Image(systemName: viewModel.isFavorite ? "star.fill" : "star")
                        .foregroundColor(viewModel.isFavorite ? .yellow : .gray)
                }
                .buttonStyle(.plain)
                .padding(.trailing, 8)
        }
        .frame(maxWidth: .infinity)
    }
}
