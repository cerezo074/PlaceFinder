//
//  SplashScreenView.swift
//  PlaceFinder
//
//  Created by Eli Pacheco Hoyos on 30/12/24.
//

import SwiftUI

struct SplashScreenView: View {

    @StateObject private var viewModel: SplashScreenViewModel
    
    init(viewModel: SplashScreenViewModel) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .resizable()
                .frame(width: 100, height: 100)
                .scaleEffect(viewModel.isAnimating ? 1.2 : 1.0)
                .rotationEffect(Angle(degrees: viewModel.isAnimating ? 360 : 0))
                .animation(
                    Animation.easeInOut(
                        duration: 1.5
                    ).repeatForever(
                        autoreverses: true
                    ),
                    value: viewModel.isAnimating
                )
            
            Text("Place Finder...")
                .font(.headline)
                .padding(.top, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
        .onAppear {
            viewModel.isAnimating = true
        }.task {
            await viewModel.viewDidAppear()
        }
    }
}

#Preview {
    SplashScreenView(
        viewModel: .init(
            domainDependencies: EmptyFactory.emptyListPlaces,
            didFinishLoading: {}
        )
    )
}
