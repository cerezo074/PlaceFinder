//
//  LocationMapView.swift
//  PlaceFinder
//
//  Created by Eli Pacheco Hoyos on 30/12/24.
//

import SwiftUI
import MapKit

struct LocationMapView: View {

    @State
    private var cameraPosition: MapCameraPosition
    @ObservedObject
    private var viewModel: LocationViewModel
    let refreshCameraManually: Bool
    let backButtonAction: (() -> Void)?

    init(
        selectedItem: LocationViewModel,
        refreshCameraManually: Bool,
        backButtonAction: (() -> Void)? = nil
    ) {
        self.viewModel = selectedItem
        self.backButtonAction = backButtonAction
        self.cameraPosition = Constants.initialCameraPosition
        self.refreshCameraManually = refreshCameraManually
        
        if refreshCameraManually {
            viewModel.refreshCameraManually()
        }
    }
    
    var body: some View {
        VStack {
            switch viewModel.locationState {
            case .loading:
                ProgressView(viewModel.loadingMessage)
                    .task {
                        await viewModel.validateLocation()
                    }
            case .success:
                Map(position: $cameraPosition) {
                    Marker(
                        viewModel.detailTitle,
                        monogram: Text(viewModel.country),
                        coordinate: viewModel.locationCoordinate
                    )
                }
            case .failure(let errorMsg):
                Text("\(errorMsg)")
                    .foregroundColor(.red)
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
        }.task {
            guard !refreshCameraManually else { return }
            await MainActor.run {
                centerMap(on: viewModel.locationCoordinate)
            }
        }.onReceive(viewModel.updateCameraPosition) { _ in
            Task {
                await MainActor.run {
                    centerMap(on: viewModel.locationCoordinate)
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
                Image(systemName: Constants.backButtonIcon)
                Text(viewModel.backButtonLabel)
            }
        }
    }
    
    private func centerMap(on coordinate: CLLocationCoordinate2D) {
        cameraPosition = .camera(
            MapCamera(
                centerCoordinate: coordinate,
                distance: Constants.defaultMapDistance,
                heading: Constants.defaultHeading,
                pitch: Constants.defaultPitch
            )
        )
    }
    
    // MARK: - Constants
    
    private enum Constants {
        static let initialCameraPosition: MapCameraPosition = .automatic
        static let defaultMapDistance: CLLocationDistance = 200_000_000
        static let defaultHeading: CLLocationDirection = 0
        static let defaultPitch: CGFloat = 0
        static let backButtonIcon = "chevron.backward"
    }
    
}
