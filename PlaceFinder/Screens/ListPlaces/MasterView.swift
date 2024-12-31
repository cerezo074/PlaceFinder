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
            VStack(alignment: .leading) {
                ForEach(items, id: \.self) {
                    makeItem($0)
                }
            }
            .padding()
            .background(.green)
        }
    }
    
    private func makeItem(_ item: String) -> some View {
        Text(item)
            .padding()
            .background(selectedItem == item ? Color.blue.opacity(0.2) : Color.clear)
            .cornerRadius(8)
            .onTapGesture {
                selectedItem = item
            }
    }
}
