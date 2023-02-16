//
//  APISession.swift
//  TransferGoTest
//
//  Created by Vitalii Kizlov on 10.02.2023.
//

import Foundation
import Combine

public struct ApiSession: APISessionProviding {
    public init() {}
    
    private let apiSessionQueue = DispatchQueue(label: "com.API",
                                                qos: .default)

    private let decoder = JSONDecoder()

    public func execute<T>(_ requestProvider: RequestProviding) -> AnyPublisher<T, Error> where T : Codable {
        return URLSession.shared.dataTaskPublisher(for: requestProvider.urlRequest())
            .tryMap { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                      200...299 ~= httpResponse.statusCode else {
                    throw URLError(.badServerResponse)
                }
                return element.data
            }
            .receive(on: apiSessionQueue)
            .decode(type: T.self, decoder: decoder)
            .eraseToAnyPublisher()

    }
}
