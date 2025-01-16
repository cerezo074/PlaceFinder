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
            Image(systemName: Constants.imageName)
                .resizable()
                .frame(width: Constants.imageSize, height: Constants.imageSize)
                .scaleEffect(viewModel.isAnimating ? Constants.scaleEffectMax : Constants.scaleEffectMin)
                .rotationEffect(Angle(degrees: viewModel.isAnimating ? Constants.rotationMax : Constants.rotationMin))
                .animation(
                    Animation.easeInOut(
                        duration: Constants.animationDuration
                    ).repeatForever(
                        autoreverses: Constants.animationAutoreverses
                    ),
                    value: viewModel.isAnimating
                )
            
            Text(viewModel.title)
                .font(Constants.textFont)
                .padding(.top, Constants.textPadding)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
        .onAppear {
            viewModel.isAnimating = true
        }.task {
            await viewModel.viewDidAppear()
        }
    }
    
    // MARK: - Constants
    private enum Constants {
        static let imageName = "globe"
        static let imageSize: CGFloat = 100
        static let scaleEffectMax: CGFloat = 1.2
        static let scaleEffectMin: CGFloat = 1.0
        static let rotationMax: Double = 360
        static let rotationMin: Double = 0
        static let animationDuration: Double = 1.5
        static let animationAutoreverses = true
        static let textFont: Font = .headline
        static let textPadding: CGFloat = 20
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
