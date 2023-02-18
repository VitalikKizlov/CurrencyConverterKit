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

public protocol ExchangeRateServiceProtocol: AnyObject {
    func changeSenderAmount(_ amount: Double)
    func changeReceiverAmount(_ amount: Double)
    func performCurrenciesSwap()

    var exchangeDataPublisher: AnyPublisher<ExchangeData, Error> { get }
}

public final class ExchangeRateService: ExchangeRateServiceProtocol {

    // MARK: - Dependencies

    @Injected(\.exchangeRateProvider) private var exchangeRateProvider: ExchangeRateProviding
    @Injected(\.countriesStoreService) private var countriesStoreService: CountriesStoreProtocol

    private var exchangeData: ExchangeData?
    private var subscriptions: Set<AnyCancellable> = []

    private let exchangeDataSubject = PassthroughSubject<ExchangeData, Error>()
    public lazy var exchangeDataPublisher = exchangeDataSubject.eraseToAnyPublisher()

    public init() {
        exchangeData = configureExchangeData()
        getRatesFromSender()

        countriesStoreService.countryItemSubjectPublisher
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.exchangeData = self.configureExchangeData()
                self.getRatesFromSender()
            }
            .store(in: &subscriptions)
    }

    public func changeSenderAmount(_ amount: Double) {
        exchangeData?.changeSenderAmount(amount)
        getRatesFromSender()
    }

    public func changeReceiverAmount(_ amount: Double) {
        exchangeData?.changeReceiverAmount(amount)
        getRatesFromReceiver()
    }

    public func performCurrenciesSwap() {
        exchangeData?.swap()
        getRatesFromSender()
    }

    private func getRatesFromSender() {
        guard let from = exchangeData?.sender.country.currency.rawValue,
              let to = exchangeData?.receiver.country.currency.rawValue,
              let amount = exchangeData?.sender.amount
        else { return }

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
                guard let self = self,
                      let exchangeData = self.exchangeData
                else { return }

                let sender = SenderDataItem(country: exchangeData.sender.country, amount: result.fromAmount)
                let receiver = ReceiverDataItem(country: exchangeData.receiver.country, amount: result.toAmount)
                let data = ExchangeData(sender: sender, receiver: receiver)

                self.exchangeData = data
                self.exchangeDataSubject.send(data)
            }
            .store(in: &subscriptions)
    }

    private func getRatesFromReceiver() {
        guard let from = exchangeData?.receiver.country.currency.rawValue,
              let to = exchangeData?.sender.country.currency.rawValue,
              let amount = exchangeData?.receiver.amount
        else { return }

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
                guard let self = self,
                      let exchangeData = self.exchangeData
                else { return }

                let sender = SenderDataItem(country: exchangeData.sender.country, amount: result.toAmount)
                let receiver = ReceiverDataItem(country: exchangeData.receiver.country, amount: result.fromAmount)
                let data = ExchangeData(sender: sender, receiver: receiver)

                self.exchangeData = data
                self.exchangeDataSubject.send(data)
            }
            .store(in: &subscriptions)
    }

    private func configureExchangeData() -> ExchangeData {
        let senderCountry = countriesStoreService.senderCountry()
        let receiverCountry = countriesStoreService.receiverCountry()
        let sender = SenderDataItem(country: senderCountry, amount: 300)
        let receiver = ReceiverDataItem(country: receiverCountry, amount: 0)
        return ExchangeData(sender: sender, receiver: receiver)
    }
}
