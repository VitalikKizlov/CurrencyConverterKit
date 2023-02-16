//
//  File.swift
//  
//
//  Created by Vitalii Kizlov on 16.02.2023.
//

import Foundation
import Injection
import Networking

public extension InjectedValues {
    var exchangeRateProvider: ExchangeRateProviding {
        get { Self[ExchangeRateProviderKey.self] }
        set { Self[ExchangeRateProviderKey.self] = newValue }
    }
}

public extension InjectedValues {
    var exchangeRateService: ExchangeRateServiceProtocol {
        get { Self[ExchangeRateServiceKey.self] }
        set { Self[ExchangeRateServiceKey.self] = newValue }
    }
}

public extension InjectedValues {
    var countriesStoreService: CountriesStoreProtocol {
        get { Self[CountriesStoreServiceKey.self] }
        set { Self[CountriesStoreServiceKey.self] = newValue }
    }
}
