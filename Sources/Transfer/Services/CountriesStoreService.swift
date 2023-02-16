//
//  File.swift
//  
//
//  Created by Vitalii Kizlov on 16.02.2023.
//

import Foundation

public protocol CountriesStoreProtocol: AnyObject {
    func countries() -> [Country]
    func senderCountry() -> Country
    func receiverCountry() -> Country
}

public final class CountriesStoreService: CountriesStoreProtocol {

    private var countryItems: [Country] = [.poland, .ukraine, .germany, .greatBritain]
    private var senderCountryItem: Country = .poland
    private var receiverCountryItem: Country = .ukraine

    public init() {
        
    }

    public func countries() -> [Country] {
        return countryItems
    }

    public func senderCountry() -> Country {
        return senderCountryItem
    }

    public func receiverCountry() -> Country {
        return receiverCountryItem
    }
}
