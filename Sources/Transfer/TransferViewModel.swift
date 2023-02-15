//
//  File.swift
//  
//
//  Created by Vitalii Kizlov on 14.02.2023.
//

import Foundation
import UIKit
import Combine
import Utilities
import Injection
import Networking
import Models

public final class TransferViewModel {

    // MARK: - Dependencies

    @Injected(\.exchangeRateProvider) private var exchangeRateProvider: ExchangeRateProviding

    // MARK: - Input

    public let viewInput = PassthroughSubject<TransferView.ViewAction, Never>()
    private lazy var viewInputPublisher = viewInput.eraseToAnyPublisher()

    // MARK: - Properties

    @Published public var state: LoadingState = viewModelIdleState()
    private var subscriptions: Set<AnyCancellable> = []

    public init() {
        getRates()

        viewInput
            .sink { [weak self] action in
                guard let self = self else { return }
                self.proceedViewAction(action)
            }
            .store(in: &subscriptions)
    }

    private func proceedViewAction(_ action: TransferView.ViewAction) {
        switch action {
        case .swapViewTapped:
            guard case .loaded(var exchangeData) = state else { return }

            exchangeData.swap()
            state = .idle(exchangeData)

            getRates()
        case .sendingFromViewTapped:
            print("send from")
        case .receiveViewTapped:
            print("send to")
        }
    }

    private static func viewModelIdleState() -> LoadingState {
        let poland = Country(image: UIImage(systemName: "flag")!, currency: .pln)
        let ukraine = Country(image: UIImage(systemName: "flag")!, currency: .uah)
        let sender = SenderDataItem(country: poland, amount: 300)
        let receiver = ReceiverDataItem(country: ukraine, amount: 0)
        let exchangeData = ExchangeData(sender: sender, receiver: receiver)
        return .idle(exchangeData)
    }

    private func getRates() {
        guard case .idle(let exchangeData) = state else { return }

        let from = exchangeData.sender.country.currency.rawValue
        let to = exchangeData.receiver.country.currency.rawValue
        let amount = exchangeData.sender.amount

        let parameters = ExchangeRateParameters(from: from, to: to, amount: amount)
        exchangeRateProvider.getExchangeRate(parameters)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    //self.state = .failed(error)
                    print(error.localizedDescription)
                case .finished:
                    //self.state = .idle
                    print("ffff")
                }
            } receiveValue: { [weak self] result in
                let sender = SenderDataItem(country: exchangeData.sender.country, amount: result.fromAmount)
                let receiver = ReceiverDataItem(country: exchangeData.receiver.country, amount: result.toAmount)
                let exchangeData = ExchangeData(sender: sender, receiver: receiver)

                self?.state = .loaded(exchangeData)
            }
            .store(in: &subscriptions)
    }
}

extension TransferViewModel {
    public enum LoadingState: Equatable {
        case idle(ExchangeData)
        case loading
        case loaded(ExchangeData)
        case failed(Error)

        static public func == (lhs: TransferViewModel.LoadingState, rhs: TransferViewModel.LoadingState) -> Bool {
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
