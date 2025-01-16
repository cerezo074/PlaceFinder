//
//  SearchBar.swift
//  PlaceFinder
//
//  Created by Eli Pacheco Hoyos on 8/01/25.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    let isLoading: Bool
    let placeholder: String

    var body: some View {
        HStack {
            TextField(placeholder, text: $text)
                .textFieldStyle(.roundedBorder)
                .padding(.leading, Constants.textFieldPaddingLeading)
                .disabled(isLoading)

            if !text.isEmpty, !isLoading {
                Button(action: { text = "" }) {
                    Image(systemName: Constants.clearButtonImage)
                        .foregroundColor(Constants.clearButtonColor)
                }
                .padding(.trailing, Constants.buttonPaddingTrailing)
            } else if isLoading {
                ProgressView()
            }
        }
        .padding(.vertical, Constants.containerPaddingVertical)
        .padding(.horizontal, Constants.containerPaddingHorizontal)
        .background(Constants.backgroundColor)
        .cornerRadius(Constants.cornerRadius)
        .padding(.horizontal, Constants.overallPaddingHorizontal)
    }
    
    // MARK: - Constants
    private enum Constants {
        static let textFieldPaddingLeading: CGFloat = 8
        static let buttonPaddingTrailing: CGFloat = 8
        static let containerPaddingVertical: CGFloat = 4
        static let containerPaddingHorizontal: CGFloat = 8
        static let backgroundColor = Color(.systemGray6)
        static let cornerRadius: CGFloat = 8
        static let overallPaddingHorizontal: CGFloat = 16
        static let clearButtonImage = "xmark.circle.fill"
        static let clearButtonColor = Color.gray
    }
}
