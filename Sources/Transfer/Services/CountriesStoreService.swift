//
//  File.swift
//  
//
//  Created by Vitalii Kizlov on 16.02.2023.
//

import Foundation
import Combine

public protocol CountriesStoreProtocol: AnyObject {
    func countriesForSender() -> [Country]
    func countriesForReceiver() -> [Country]
    func senderCountry() -> Country
    func receiverCountry() -> Country
    func configureSenderCountry(for name: String)
    func configureReceiverCountry(for name: String)

    var countryItemSubjectPublisher: AnyPublisher<Void, Never> { get }
}

public final class CountriesStoreService: CountriesStoreProtocol {

    private var countryItems: [Country] = [.poland, .ukraine, .germany, .greatBritain]
    private var senderCountryItem: Country = .poland
    private var receiverCountryItem: Country = .ukraine

    private let countryItemSubject = PassthroughSubject<Void, Never>()
    public lazy var countryItemSubjectPublisher = countryItemSubject.eraseToAnyPublisher()

    private var subscriptions: Set<AnyCancellable> = []

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

    public func configureSenderCountry(for name: String) {
        guard let country = countryItems.first(where: { $0.name == name }) else { return }
        senderCountryItem = country

        countryItemSubject.send(())
    }

    public func configureReceiverCountry(for name: String) {
        guard let country = countryItems.first(where: { $0.name == name }) else { return }
        receiverCountryItem = country

        countryItemSubject.send(())
    }
}
