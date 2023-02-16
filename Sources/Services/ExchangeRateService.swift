//
//  File.swift
//  
//
//  Created by Vitalii Kizlov on 15.02.2023.
//

import Foundation
import UIKit
import Combine
import Networking
import Injection
import Models

public protocol ExchangeRateServiceProtocol: AnyObject {
    func changeSenderAmount(_ amount: Double)
    func changeReceiverAmount(_ amount: Double)
    func performCurrenciesSwap()

    var exchangeDataPublisher: AnyPublisher<ExchangeData, Error> { get }
}

public final class ExchangeRateService: ExchangeRateServiceProtocol {

    // MARK: - Dependencies

    @Injected(\.exchangeRateProvider) private var exchangeRateProvider: ExchangeRateProviding

    private var exchangeData = exchangeData()
    private var subscriptions: Set<AnyCancellable> = []

    private let exchangeDataSubject = PassthroughSubject<ExchangeData, Error>()
    public lazy var exchangeDataPublisher = exchangeDataSubject.eraseToAnyPublisher()

    public init() {
        getRatesFromSender()
    }

    public func changeSenderAmount(_ amount: Double) {
        exchangeData.changeSenderAmount(amount)
        getRatesFromSender()
    }

    public func changeReceiverAmount(_ amount: Double) {
        exchangeData.changeReceiverAmount(amount)
        getRatesFromReceiver()
    }

    public func performCurrenciesSwap() {
        exchangeData.swap()
        getRatesFromSender()
    }

    private func getRatesFromSender() {
        let from = exchangeData.sender.country.currency.rawValue
        let to = exchangeData.receiver.country.currency.rawValue
        let amount = exchangeData.sender.amount

        let parameters = ExchangeRateParameters(from: from, to: to, amount: amount)
        exchangeRateProvider.getExchangeRate(parameters)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.exchangeDataSubject.send(completion: .failure(error))
                case .finished:
                    print("finished")
                }
            } receiveValue: { [weak self] result in
                guard let self = self else { return }

                let sender = SenderDataItem(country: self.exchangeData.sender.country, amount: result.fromAmount)
                let receiver = ReceiverDataItem(country: self.exchangeData.receiver.country, amount: result.toAmount)
                let exchangeData = ExchangeData(sender: sender, receiver: receiver)

                self.exchangeData = exchangeData
                self.exchangeDataSubject.send(exchangeData)
            }
            .store(in: &subscriptions)
    }

    private func getRatesFromReceiver() {
        let from = exchangeData.receiver.country.currency.rawValue
        let to = exchangeData.sender.country.currency.rawValue
        let amount = exchangeData.receiver.amount

        let parameters = ExchangeRateParameters(from: from, to: to, amount: amount)
        exchangeRateProvider.getExchangeRate(parameters)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.exchangeDataSubject.send(completion: .failure(error))
                case .finished:
                    break
                }
            } receiveValue: { [weak self] result in
                guard let self = self else { return }

                let sender = SenderDataItem(country: self.exchangeData.sender.country, amount: result.toAmount)
                let receiver = ReceiverDataItem(country: self.exchangeData.receiver.country, amount: result.fromAmount)
                let exchangeData = ExchangeData(sender: sender, receiver: receiver)

                self.exchangeData = exchangeData
                self.exchangeDataSubject.send(exchangeData)
            }
            .store(in: &subscriptions)
    }

    private static func exchangeData() -> ExchangeData {
        let poland = Country(image: UIImage(systemName: "flag")!, currency: .pln)
        let ukraine = Country(image: UIImage(systemName: "flag")!, currency: .uah)
        let sender = SenderDataItem(country: poland, amount: 300)
        let receiver = ReceiverDataItem(country: ukraine, amount: 0)
        return ExchangeData(sender: sender, receiver: receiver)
    }
}
