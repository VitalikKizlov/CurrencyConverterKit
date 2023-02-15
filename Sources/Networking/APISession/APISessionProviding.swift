//
//  APISession.swift
//  TransferGoTest
//
//  Created by Vitalii Kizlov on 10.02.2023.
//

import Foundation
import Combine

public protocol APISessionProviding {
    func execute<T: Codable>(_ requestProvider: RequestProviding) -> AnyPublisher<T, Error>
}
