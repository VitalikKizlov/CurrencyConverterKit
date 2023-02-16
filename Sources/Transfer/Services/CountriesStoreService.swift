//
//  File.swift
//  
//
//  Created by Vitalii Kizlov on 16.02.2023.
//

import Foundation

public protocol CountriesStoreProtocol: AnyObject {
    func countriesForSender() -> [Country]
    func countriesForReceiver() -> [Country]
    func senderCountry() -> Country
    func receiverCountry() -> Country
}

public final class CountriesStoreService: CountriesStoreProtocol {

    private var countryItems: [Country] = [.poland, .ukraine, .germany, .greatBritain]
    private var senderCountryItem: Country = .poland
    private var receiverCountryItem: Country = .ukraine

    public init() {

    }

    public func countriesForSender() -> [Country] {
        return countryItems.filter({ $0 != senderCountryItem })
    }

    public func countriesForReceiver() -> [Country] {
        return countryItems.filter({ $0 != receiverCountryItem })
    }

    public func senderCountry() -> Country {
        return senderCountryItem
    }

    public func receiverCountry() -> Country {
        return receiverCountryItem
    }
}
