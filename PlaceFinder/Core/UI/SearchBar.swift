//
//  SearchBar.swift
//  PlaceFinder
//
//  Created by Eli Pacheco Hoyos on 8/01/25.
//

import SwiftUI

struct SearchBar: View {
    @Binding
    var text: String
    let isLoading: Bool
    let placeholder: String

    var body: some View {
        HStack {
            TextField(placeholder, text: $text)
                .textFieldStyle(.roundedBorder)
                .padding(.leading, 8)
                .disabled(isLoading)

            if !text.isEmpty, !isLoading {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
                .padding(.trailing, 8)
            } else if isLoading {
                ProgressView()
            }
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 8)
        .background(Color(.systemGray6))
        .cornerRadius(8)
        .padding(.horizontal)
    }
}
