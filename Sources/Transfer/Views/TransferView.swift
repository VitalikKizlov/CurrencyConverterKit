//
//  File.swift
//  
//
//  Created by Vitalii Kizlov on 14.02.2023.
//

import UIKit
import Utilities
import Combine
import CombineCocoa

public final class TransferView: UIView {

    @AutoLayoutable private var stackView = UIStackView()
    @AutoLayoutable private var senderExchangeDataView = ExchangeDataView()
    @AutoLayoutable private var receiverExchangeDataView = ExchangeDataView()
    @AutoLayoutable private var swapView = SwapView()

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
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
    }

    private func addSubviews() {
        stackView.addArrangedSubview(senderExchangeDataView)
        stackView.addArrangedSubview(receiverExchangeDataView)

        addSubview(stackView)
        addSubview(swapView)

        let constraints = stackView.constraintsForAnchoringTo(boundsOf: self, padding: 8)
        NSLayoutConstraint.activate(constraints)

        NSLayoutConstraint.activate([
            swapView.centerYAnchor.constraint(equalTo: centerYAnchor),
            swapView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 44),
            swapView.widthAnchor.constraint(equalToConstant: 36),
            swapView.heightAnchor.constraint(equalToConstant: 36)
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
    }

    // MARK: - Public

    public func configure(_ viewModel: TransferViewViewModel) {
        senderExchangeDataView.configure(viewModel.senderViewViewModel)
        receiverExchangeDataView.configure(viewModel.receiverViewViewModel)
    }
}

public struct TransferViewViewModel {
    public let senderViewViewModel: ExchangeDataViewViewModel
    public let receiverViewViewModel: ExchangeDataViewViewModel

    public init(senderViewViewModel: ExchangeDataViewViewModel, receiverViewViewModel: ExchangeDataViewViewModel) {
        self.senderViewViewModel = senderViewViewModel
        self.receiverViewViewModel = receiverViewViewModel
    }
}

extension TransferView {
    public enum ViewAction {
        case swapViewTapped
        case sendingFromViewTapped
        case receiveViewTapped
    }
}
