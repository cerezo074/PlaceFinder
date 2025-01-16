//
//  LocationMenuView.swift
//  PlaceFinder
//
//  Created by Eli Pacheco Hoyos on 30/12/24.
//

import SwiftUI

struct LocationMenuView: View {
    @Binding var selectedItem: LocationViewModel?
    @Binding var searchText: String
    let placeholder: String
    let isLoading: Bool
    let items: [LocationViewModel]
    let toggleFavoriteItem: (LocationViewModel) -> Void
    
    var body: some View {
        VStack {
            SearchBar(
                text: $searchText,
                isLoading: isLoading,
                placeholder: placeholder
            )
            ScrollView(showsIndicators: false) {
                LazyVStack(alignment: .leading) {
                    ForEach(items, id: \.self) { item in
                        makeItem(item)
                    }
                }
                .padding()
                .background(Constants.backgroundColor)
            }
        }
    }

    private func makeItem(_ item: LocationViewModel) -> some View {
        MenuRowItemView(
            viewModel: item,
            didTapItem: {
                viewModel in selectedItem = viewModel
            },
            didTapFavorite: { viewModel in toggleFavoriteItem(viewModel) }
        )
        .background(
            selectedItem == item
                ? Constants.selectedItemColor.opacity(Constants.selectedItemOpacity)
                : .clear
        )
    }
    
    // MARK: - Constants
    
    private enum Constants {
        static let selectedItemOpacity: Double = 0.6
        static let backgroundColor: Color = .green
        static let selectedItemColor: Color = .yellow
    }
}

struct MenuRowItemView: View {
    @ObservedObject var viewModel: LocationViewModel
    var didTapItem: (LocationViewModel) -> Void
    var didTapFavorite: (LocationViewModel) -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: Constants.itemSpacing) {
                Text(viewModel.menuTitle)
                Text(viewModel.detailDescription)
                    .font(.subheadline)
            }
            .padding(Constants.padding)
            .onTapGesture {
                didTapItem(viewModel)
            }

            Spacer()

            Button(action: {
                didTapFavorite(viewModel)
            }) {
                Image(
                    systemName: viewModel.isFavorite ? Constants.selectedImage : Constants.unselectedImage
                )
                .foregroundColor(viewModel.isFavorite ? Constants.selectedColor : Constants.unselectedColor)
            }
            .buttonStyle(.plain)
            .padding(.trailing, Constants.scrollViewPadding)
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Constants

    private enum Constants {
        static let itemSpacing: CGFloat = 9
        static let padding: CGFloat = 7
        static let scrollViewPadding: CGFloat = 8
        static let selectedImage: String = "star.fill"
        static let unselectedImage: String = "star"
        static let selectedColor: Color = .yellow
        static let unselectedColor: Color = .gray
    }
}
