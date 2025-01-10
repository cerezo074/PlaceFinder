//
//  NetworkProviderMock.swift
//  PlaceFinder
//
//  Created by Eli Pacheco Hoyos on 9/01/25.
//

@testable import PlaceFinder
import Foundation

class NetworkProviderMock<Data>: NetworkServices {
    
    var data: Data?
    var shouldTriggerErrorOnRead: Bool = false
    
    func fetchData<T>(
        of type: T.Type?,
        with requestGenerator: any PlaceFinder.RestfulRequestGenerator
    ) async throws -> T? where T : Decodable {
        guard !shouldTriggerErrorOnRead else {
            throw URLError(.badServerResponse)
        }
        
        return data as? T
    }
    
}
