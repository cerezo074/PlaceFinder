//
//  RestfulEndpoint.swift
//  PlaceFinder
//
//  Created by Eli Pacheco Hoyos on 31/12/24.
//

import Foundation

struct RestfulEndpoint {
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }

    let scheme: String
    let host: String
    let path: String
    let method: HTTPMethod
    let queryParams: [String: String]
    let headers: [String: String]

    init(
        scheme: String,
        host: String,
        path: String,
        method: HTTPMethod,
        queryParams: [String: String] = [:],
        headers: [String: String] = [:]
    ) {
        self.scheme = scheme
        self.host = host
        self.path = path
        self.method = method
        self.queryParams = queryParams
        self.headers = headers
    }

    func makeURLRequest() -> URLRequest? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }

        guard let url = components.url else {
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        headers.forEach {
            request.setValue($1, forHTTPHeaderField: $0)
        }
        
        return request
    }
}
