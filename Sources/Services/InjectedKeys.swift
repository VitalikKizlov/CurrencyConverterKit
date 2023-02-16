//
//  InjectedKeys.swift
//  TransferGoTest
//
//  Created by Vitalii Kizlov on 11.02.2023.
//

import Foundation
import Injection
import Networking

public struct ExchangeRateProviderKey: InjectionKey {
    public static var currentValue: ExchangeRateProviding = ExchangeRateProvider()
}

public struct ExchangeRateServiceKey: InjectionKey {
    public static var currentValue: ExchangeRateServiceProtocol = ExchangeRateService()
}
