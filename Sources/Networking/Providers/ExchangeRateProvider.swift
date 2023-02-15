//
//  SearchProvider.swift
//  TransferGoTest
//
//  Created by Vitalii Kizlov on 11.02.2023.
//

import Foundation
import Combine
import Models

public protocol ExchangeRateProviding {
    func getExchangeRate(_ parameters: ExchangeRateParameters) -> AnyPublisher<ExchangeRateData, Error>
}

public struct ExchangeRateProvider: ExchangeRateProviding {

    let apiSession: APISessionProviding

    public init(apiSession: APISessionProviding = ApiSession()) {
        self.apiSession = apiSession
    }

    public func getExchangeRate(_ parameters: ExchangeRateParameters) -> AnyPublisher<ExchangeRateData, Error> {
        apiSession.execute(ExchangeRateEnpoint.exchangeRates(parameters))
    }
}

