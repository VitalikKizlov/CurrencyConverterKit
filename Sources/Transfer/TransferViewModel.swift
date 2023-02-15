//
//  File.swift
//  
//
//  Created by Vitalii Kizlov on 14.02.2023.
//

import Foundation
import Combine
import Utilities
import Injection
import Networking

public final class TransferViewModel {

    @Injected(\.exchangeRateProvider) private var exchangeRateProvider: ExchangeRateProviding

    public let viewInput = PassthroughSubject<TransferView.ViewAction, Never>()
    private lazy var viewInputPublisher = viewInput.eraseToAnyPublisher()

    private var subscriptions: Set<AnyCancellable> = []

    public init() {
        let parameters = ExchangeRateParameters(from: "PLN", to: "UAH", amount: 300)
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
                print(result)
            }
            .store(in: &subscriptions)

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
            print("tapppppp")
        case .sendingFromViewTapped:
            print("send from")
        case .receiveViewTapped:
            print("send to")
        }
    }
}

extension TransferViewModel {
    enum LoadingState: Equatable {
        case idle
        case loading
        case loaded
        case failed(Error)

        static func == (lhs: TransferViewModel.LoadingState, rhs: TransferViewModel.LoadingState) -> Bool {
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
