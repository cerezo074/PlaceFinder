//
//  HTTPError.swift
//  PlaceFinder
//
//  Created by Eli Pacheco Hoyos on 31/12/24.
//

import Foundation

struct HTTPError: LocalizedError {
    let statusCode: Int
    let responseBody: [String: Any]?

    var errorDescription: String? {
        if let responseBody = responseBody {
            return "HTTP Error \(statusCode): \(responseBody)"
        } else {
            return "HTTP Error \(statusCode): No response body"
        }
    }
}
