//
//  File.swift
//  
//
//  Created by Vitalii Kizlov on 14.02.2023.
//

import UIKit
import Combine
import CombineCocoa

public final class CurrencyConverterView: UIView {

    @AutoLayoutable private var stackView = UIStackView()
    @AutoLayoutable private var senderExchangeDataView = ExchangeDataView()
    @AutoLayoutable private var receiverExchangeDataView = ExchangeDataView()
    @AutoLayoutable private var swapView = SwapView()
    @AutoLayoutable private var exchangeRateView = ExchangeRateView()
    @AutoLayoutable private var errorLabel = UILabel()

    private let viewAction = PassthroughSubject<ViewAction, Never>()
    public lazy var viewActionPublisher = viewAction.eraseToAnyPublisher()

    private var subscriptions: Set<AnyCancellable> = []

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        addSubviews()
        setupBindings()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private

    private func setupSubviews() {
        stackView.axis = .vertical
        stackView.spacing = 36
        stackView.distribution = .fill
        stackView.alignment = .fill

        errorLabel.textColor = .red
        errorLabel.numberOfLines = 1
        errorLabel.isHidden = true
    }

    private func addSubviews() {
        stackView.addArrangedSubview(senderExchangeDataView)
        stackView.addArrangedSubview(receiverExchangeDataView)

        addSubview(stackView)
        addSubview(swapView)
        addSubview(exchangeRateView)
        addSubview(errorLabel)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),

            swapView.centerYAnchor.constraint(equalTo: stackView.centerYAnchor),
            swapView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 36),
            swapView.widthAnchor.constraint(equalToConstant: 36),
            swapView.heightAnchor.constraint(equalToConstant: 36),

            exchangeRateView.centerYAnchor.constraint(equalTo: swapView.centerYAnchor),
            exchangeRateView.leadingAnchor.constraint(equalTo: swapView.trailingAnchor, constant: 24),
            exchangeRateView.trailingAnchor.constraint(greaterThanOrEqualTo: trailingAnchor, constant: -16),

            errorLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            errorLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            errorLabel.heightAnchor.constraint(equalToConstant: 36)
        ])
    }

    private func setupBindings() {
        swapView.tapGesture
            .tapPublisher
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.viewAction.send(.swapViewTapped)
            }
            .store(in: &subscriptions)

        senderExchangeDataView.textfield
            .textPublisher
            .debounce(for: 0.2, scheduler: DispatchQueue.main)
            .compactMap({ $0 })
            .sink { [weak self] text in
                guard let self = self else { return }

                if text.isEmpty { return }

                self.viewAction.send(.senderAmountValueChanged(text))
            }
            .store(in: &subscriptions)

        receiverExchangeDataView.textfield
            .textPublisher
            .debounce(for: 0.2, scheduler: DispatchQueue.main)
            .compactMap({ $0 })
            .sink { [weak self] text in
                guard let self = self else { return }

                if text.isEmpty { return }

                self.viewAction.send(.receiverAmountValueChanged(text))
            }
            .store(in: &subscriptions)

        senderExchangeDataView.countryView.tapGesture
            .tapPublisher
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.viewAction.send(.sendingFromViewTapped)
            }
            .store(in: &subscriptions)

        receiverExchangeDataView.countryView.tapGesture
            .tapPublisher
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.viewAction.send(.receiveViewTapped)
            }
            .store(in: &subscriptions)
    }

    // MARK: - Public

    public func configure(_ viewModel: TransferViewViewModel) {
        senderExchangeDataView.configure(viewModel.senderViewViewModel)
        receiverExchangeDataView.configure(viewModel.receiverViewViewModel)
        exchangeRateView.configure(viewModel.exchangeRateViewViewModel)
        errorLabel.isHidden = true
    }

    public func configureErrorState(_ viewModel: TransferViewErrorViewModel) {
        errorLabel.text = viewModel.message
        errorLabel.isHidden = false
    }
}

public struct TransferViewViewModel {
    public let senderViewViewModel: ExchangeDataViewViewModel
    public let receiverViewViewModel: ExchangeDataViewViewModel
    public let exchangeRateViewViewModel: ExchangeRateViewViewModel

    public init(
        senderViewViewModel: ExchangeDataViewViewModel,
        receiverViewViewModel: ExchangeDataViewViewModel,
        exchangeRateViewViewModel: ExchangeRateViewViewModel
    ) {
        self.senderViewViewModel = senderViewViewModel
        self.receiverViewViewModel = receiverViewViewModel
        self.exchangeRateViewViewModel = exchangeRateViewViewModel
    }
}

public struct TransferViewErrorViewModel {
    public let currency: Currency

    public var message: String {
        return "Maximum sending amount \(currency.limit) \(currency.rawValue)"
    }

    public init(_ currency: Currency) {
        self.currency = currency
    }
}

extension CurrencyConverterView {
    public enum ViewAction {
        case swapViewTapped
        case sendingFromViewTapped
        case receiveViewTapped
        case senderAmountValueChanged(String)
        case receiverAmountValueChanged(String)
    }
}
