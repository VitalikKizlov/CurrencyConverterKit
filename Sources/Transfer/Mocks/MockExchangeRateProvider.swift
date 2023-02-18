//
//  File.swift
//  
//
//  Created by Vitalii Kizlov on 18.02.2023.
//

import Foundation
import Combine

public struct MockExchangeRateProvider: ExchangeRateProviding {
    public func getExchangeRate(_ parameters: ExchangeRateParameters) -> AnyPublisher<ExchangeRateData, Error> {
        Just(ExchangeRateData(from: Currency(rawValue: "PLN")!, to: Currency(rawValue: "UAH")!, rate: 8.26103, fromAmount: 300, toAmount: 2478.31))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
