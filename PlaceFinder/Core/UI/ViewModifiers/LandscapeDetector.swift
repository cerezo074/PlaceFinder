//
//  LandscapeDetector.swift
//  PlaceFinder
//
//  Created by Eli Pacheco Hoyos on 30/12/24.
//


import SwiftUI
import Combine

struct LandscapeDetector: ViewModifier {
    @Binding
    var isLandscape: Bool
    
    private let orientationChanged = NotificationCenter.default.publisher(
        for: UIDevice.orientationDidChangeNotification
    )

    func body(content: Content) -> some View {
        content
            .onAppear {
                UIDevice.current.beginGeneratingDeviceOrientationNotifications()
                updateOrientation()
            }
            .onDisappear {
                UIDevice.current.endGeneratingDeviceOrientationNotifications()
            }
            .onReceive(orientationChanged) { _ in
                updateOrientation()
            }
    }

    private func updateOrientation() {
        let orientation = UIDevice.current.orientation
        isLandscape = orientation.isLandscape
    }
}
