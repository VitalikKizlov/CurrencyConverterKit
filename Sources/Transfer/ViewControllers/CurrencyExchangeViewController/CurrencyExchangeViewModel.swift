//
//  File.swift
//  
//
//  Created by Vitalii Kizlov on 14.02.2023.
//

import Foundation
import UIKit
import Combine
import Injection
import Networking

public final class CurrencyExchangeViewModel {

    // MARK: - Dependencies

    @Injected(\.exchangeRateService) private var exchangeRateService: ExchangeRateServiceProtocol

    // MARK: - Input

    public let viewInput = PassthroughSubject<CurrencyConverterView.ViewAction, Never>()
    private lazy var viewInputPublisher = viewInput.eraseToAnyPublisher()

    // MARK: - Output

    @Published public var state: LoadingState = .idle

    private let isAmountValidSubject = PassthroughSubject<AmountValidParameters, Never>()
    public lazy var isAmountValidPublisher = isAmountValidSubject.eraseToAnyPublisher()

    // MARK: - Properties

    private var subscriptions: Set<AnyCancellable> = []

    public init() {
        viewInput
            .sink { [weak self] action in
                guard let self = self else { return }
                self.proceedViewAction(action)
            }
            .store(in: &subscriptions)

        exchangeRateService
            .exchangeDataPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.state = .failed(error)
                case .finished:
                    print("finished")
                }
            }, receiveValue: { [weak self] exchangeData in
                guard let self = self else { return }
                self.state = .loaded(exchangeData)
            })
            .store(in: &subscriptions)

        exchangeRateService
            .isAmountValidPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] parameters in
                guard let self = self else { return }
                self.isAmountValidSubject.send(parameters)
            }
            .store(in: &subscriptions)
    }

    private func proceedViewAction(_ action: CurrencyConverterView.ViewAction) {
        switch action {
        case .swapViewTapped:
            exchangeRateService.performCurrenciesSwap()
        case .senderAmountValueChanged(let amount):
            exchangeRateService.validateSenderAmount(Double(amount) ?? 0)
        case .receiverAmountValueChanged(let amount):
            exchangeRateService.changeReceiverAmount(Double(amount) ?? 0)
        case .sendingFromViewTapped:
            print("send from")
        case .receiveViewTapped:
            print("send to")
        }
    }
}

extension CurrencyExchangeViewModel {
    public enum LoadingState: Equatable {
        case idle
        case loading
        case loaded(ExchangeData)
        case failed(Error)

        static public func == (lhs: CurrencyExchangeViewModel.LoadingState, rhs: CurrencyExchangeViewModel.LoadingState) -> Bool {
            switch (lhs, rhs) {
            case (.idle, .idle):
                return true
            case (.loading, .loading):
                return true
            case (.loaded, .loaded):
                return true
            case (.failed, .failed):
                return true
            default:
                return false
            }
        }
    }
}
