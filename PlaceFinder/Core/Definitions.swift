//
//  Definitions.swift
//  PlaceFinder
//
//  Created by Eli Pacheco Hoyos on 30/12/24.
//

typealias VoidClousure = () -> Void

func callOnMainThread(callback: @escaping VoidClousure) async {
    await MainActor.run(body: {
        callback()
    })
}
