//
//  DetailView.swift
//  PlaceFinder
//
//  Created by Eli Pacheco Hoyos on 30/12/24.
//

import SwiftUI

struct DetailView: View {
    let selectedItem: String?
    let backButtonAction: VoidClousure?

    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack {
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
        }
        .navigationBarBackButtonHidden()
        .frame(maxWidth: .infinity)
        .if(showBackButton) { content in
            content.toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    backButton
                }
            }
        }
    }
    
    private var showBackButton: Bool {
        backButtonAction != nil
    }
    
    private var backButton: some View {
        Button(action: {
            backButtonAction?()
        }) {
            HStack {
                Image(systemName: "chevron.backward")
                Text("Back")
            }
        }
    }
}
