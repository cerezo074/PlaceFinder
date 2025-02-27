//
//  PlaceEndpointTypes.swift
//  PlaceFinder
//
//  Created by Eli Pacheco Hoyos on 31/12/24.
//

import Foundation

protocol RestfulRequestGenerator {
    func makeRequest() -> URLRequest?
}

enum PlaceEndpointTypes: RestfulRequestGenerator {
    case fetchAll
    
    var scheme: String {
        return "https"
    }
    
    var host: String {
        return "gist.githubusercontent.com"
    }
    
    var headers: [String: String] {
        switch self {
        case .fetchAll:
            return ["Content-Type": "application/json"]
        }
    }
    
    var path: String {
        switch self {
        case .fetchAll:
            return "/hernan-uala/dce8843a8edbe0b0018b32e137bc2b3a" +
            "/raw/0996accf70cb0ca0e16f9a99e0ee185fafca7af1" +
            "/cities.json"
        }
    }
    
    var method: RestfulEndpoint.HTTPMethod {
        switch self {
        case .fetchAll:
            return .get
        }
    }
    
    var queryParams: [String: String]{
        switch self {
        case .fetchAll:
            return [:]
        }
    }
    
    func makeRequest() -> URLRequest? {
        RestfulEndpoint(
            scheme: scheme,
            host: host,
            path: path,
            method: method,
            queryParams: queryParams,
            headers: headers
        ).makeURLRequest()
    }
}
