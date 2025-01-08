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
    let backButtonAction: (() -> Void)?
    
    init(
        selectedItem: LocationViewModel,
        backButtonAction: (() -> Void)? = nil
    ) {
        self.viewModel = selectedItem
        self.backButtonAction = backButtonAction
        self.cameraPosition = .automatic
    }
    
    var body: some View {
        VStack {
            switch viewModel.locationState {
            case .loading:
                ProgressView("Checking location…")
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
                .onAppear {
                    centerMap(on: viewModel.locationCoordinate)
                }
            case .failure(let errorMsg):
                Text("Error: \(errorMsg)")
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
    
    private func centerMap(on coordinate: CLLocationCoordinate2D) {
        cameraPosition = .camera(
            MapCamera(
                centerCoordinate: coordinate,
                distance: 200_000_000, // “zoom” distance
                heading: 0,
                pitch: 0
            )
        )
    }
}
