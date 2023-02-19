//
//  InjectedKeys.swift
//  TransferGoTest
//
//  Created by Vitalii Kizlov on 11.02.2023.
//

import Foundation

public struct ExchangeRateProviderKey: InjectionKey {
    public static var currentValue: ExchangeRateProviding = ProcessInfo.isRunningUnitTests ? MockExchangeRateProvider() : ExchangeRateProvider()
}

public struct ExchangeRateServiceKey: InjectionKey {
    public static var currentValue: ExchangeRateServiceProtocol = ProcessInfo.isRunningUnitTests ? MockExchangeRateService() : ExchangeRateService()
}

public struct CountriesStoreServiceKey: InjectionKey {
    public static var currentValue: CountriesStoreProtocol = ProcessInfo.isRunningUnitTests ? MockCountriesStoreService() : CountriesStoreService()
}
