//
//  File.swift
//  
//
//  Created by Vitalii Kizlov on 18.02.2023.
//

import Foundation
import Combine
import UIKit

public final class MockExchangeRateService: ExchangeRateServiceProtocol {

    public private(set) var exchangeData: ExchangeData?

    private let exchangeDataSubject = PassthroughSubject<ExchangeData, Error>()
    public lazy var exchangeDataPublisher = exchangeDataSubject.eraseToAnyPublisher()

    private let isAmountValidSubject = PassthroughSubject<AmountValidParameters, Never>()
    public lazy var isAmountValidPublisher = isAmountValidSubject.eraseToAnyPublisher()

    public init() {
        exchangeData = configureExchangeData()
    }

    public func changeReceiverAmount(_ amount: Double) {
        exchangeData?.changeReceiverAmount(amount)
    }

    public func performCurrenciesSwap() {
        exchangeData?.swap()
    }

    public func validateSenderAmount(_ amount: Double) {
        performAmountValidation(amount)
    }

    private func configureExchangeData() -> ExchangeData {
        let senderCountry = Country(name: "Poland", image: UIImage(systemName: "flag")!, currency: Currency(rawValue: "PLN")!)
        let receiverCountry = Country(name: "Ukraine", image: UIImage(systemName: "flag")!, currency: Currency(rawValue: "UAH")!)
        let sender = SenderDataItem(country: senderCountry, amount: 300)
        let receiver = ReceiverDataItem(country: receiverCountry, amount: 0)
        return ExchangeData(sender: sender, receiver: receiver)
    }

    private func performAmountValidation(_ amount: Double) {
        guard let data = exchangeData else { return }

        let isValid = data.sender.country.currency.limit > amount

        if isValid {
            changeSenderAmount(amount)
        }

        let parameters = AmountValidParameters(isValid: isValid, currency: data.sender.country.currency)
        isAmountValidSubject.send(parameters)
    }

    private func changeSenderAmount(_ amount: Double) {
        exchangeData?.changeSenderAmount(amount)
    }
}
