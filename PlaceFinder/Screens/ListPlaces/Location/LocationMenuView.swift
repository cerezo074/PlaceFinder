//
//  LocationMenuView.swift
//  PlaceFinder
//
//  Created by Eli Pacheco Hoyos on 30/12/24.
//

import SwiftUI

struct LocationMenuView: View {
    @Binding var selectedItem: LocationViewModel?
    let items: [LocationViewModel]

    var body: some View {
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
    
    private func makeItem(_ item: LocationViewModel) -> some View {
        HStack {
            Text(item.menuTitle)
                .padding()
                .cornerRadius(8)
                .onTapGesture {
                    selectedItem = item
                }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(selectedItem == item ? Color.yellow.opacity(0.6) : Color.clear)
    }
}
