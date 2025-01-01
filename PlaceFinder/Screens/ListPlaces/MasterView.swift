//
//  MasterView.swift
//  PlaceFinder
//
//  Created by Eli Pacheco Hoyos on 30/12/24.
//

import SwiftUI

struct MasterView: View {
    @Binding var selectedItem: String?
    let items: [String]

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
    
    private func makeItem(_ item: String) -> some View {
        HStack {
            Text(item)
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
