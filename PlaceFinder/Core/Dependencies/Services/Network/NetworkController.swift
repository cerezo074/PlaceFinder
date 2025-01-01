//
//  NetworkController.swift
//  PlaceFinder
//
//  Created by Eli Pacheco Hoyos on 31/12/24.
//

import Foundation

protocol NetworkProvider {
    var networkServices: NetworkServices { get }
}

protocol NetworkServices {
    func fetchData<T: Decodable>(
        of type: T.Type?,
        with requestGenerator: RestfulRequestGenerator
    ) async throws -> T?
}

class NetworkController: NetworkServices {
    
    private let urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func fetchData<T: Decodable>(
        of type: T.Type?,
        with requestGenerator: RestfulRequestGenerator
    ) async throws -> T? {
        guard let request = requestGenerator.makeRequest() else {
            throw URLError(.badURL)
        }

        let (data, response) = try await urlSession.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            if let responseData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                throw HTTPError(statusCode: httpResponse.statusCode, responseBody: responseData)
            } else {
                throw HTTPError(statusCode: httpResponse.statusCode, responseBody: nil)
            }
        }

        guard !data.isEmpty, let type = type else {
            return nil
        }

        do {
            let decoder = JSONDecoder()
            return try decoder.decode(type, from: data)
        } catch {
            throw error
        }
    }
}
