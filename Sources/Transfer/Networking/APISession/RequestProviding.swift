//
//  RequestProviding.swift
//  TransferGoTest
//
//  Created by Vitalii Kizlov on 10.02.2023.
//

import Foundation

public protocol RequestProviding {
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: [String: Any] { get }
    var headerFields: [String: String] { get }

    func urlRequest() -> URLRequest
}

extension RequestProviding {
    func urlRequest() -> URLRequest {
        var components = URLComponents()
        components.scheme = "https"
        components.host = API.backendURL
        components.path = path

        if case .get = method, !parameters.isEmpty {
            components.queryItems = parameters.compactMap { URLQueryItem(name: $0.key, value: "\($0.value)") }
        }

        guard let url = components.url else {
            preconditionFailure("Can't create URL")
        }
        
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData)
        request.httpMethod = method.rawValue

        headerFields.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        print("Request ----", request)
        return request
    }
}
