//
//  File.swift
//  
//
//  Created by Vitalii Kizlov on 20.02.2023.
//

import UIKit
import Combine

public final class CurrencyExchangeViewController: UIViewController {

    private let viewModel: CurrencyExchangeViewModel

    @AutoLayoutable private var transferView = CurrencyConverterView()

    private var subscriptions: Set<AnyCancellable> = []

    // MARK: - Init

    public init(_ viewModel: CurrencyExchangeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("This class does not support NSCoder")
    }

    // MARK: - Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addTransferView()
        setupBindings()
    }

    // MARK: - Private

    private func addTransferView() {
        view.addSubview(transferView)

        NSLayoutConstraint.activate([
            transferView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            transferView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            transferView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }

    private func setupBindings() {
        viewModel
            .$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self = self else { return }

                switch state {
                case .idle:
                    break
                case .failed(let error):
                    print(error)
                case .loading:
                    print("loading")
                case .loaded(let data):
                    self.updateTransferView(from: data)
                }
            }
            .store(in: &subscriptions)

        viewModel
            .isAmountValidPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] parameters in
                guard let self = self else { return }

                if !parameters.isValid {
                    let errorViewModel = TransferViewErrorViewModel(parameters.currency)
                    self.transferView.configureErrorState(errorViewModel)
                }
            }
            .store(in: &subscriptions)

        transferView
            .viewActionPublisher
            .sink { [weak self] action in
                guard let self = self else { return }
                switch action {
                case .sendingFromViewTapped:
                    self.showSearchViewController(.sender)
                case .receiveViewTapped:
                    self.showSearchViewController(.receiver)
                default:
                    self.viewModel.viewInput.send(action)
                }
            }
            .store(in: &subscriptions)
    }

    private func updateTransferView(from data: ExchangeData) {
        let senderCountryViewModel = CountryViewViewModel(
            image: data.sender.country.image,
            title: data.sender.country.currency.rawValue
        )

        let senderExchangeViewModel = ExchangeDataViewViewModel(
            title: "Sending from",
            countryViewViewModel: senderCountryViewModel,
            amount: data.sender.amount
        )

        let receiverCountryViewModel = CountryViewViewModel(
            image: data.receiver.country.image,
            title: data.receiver.country.currency.rawValue
        )

        let receiverExchangeViewModel = ExchangeDataViewViewModel(
            title: "Receiver gets",
            countryViewViewModel: receiverCountryViewModel,
            amount: data.receiver.amount
        )

        let exchangeRateViewViewModel = ExchangeRateViewViewModel(
            fromCurrency: data.sender.country.currency,
            toCurrency: data.receiver.country.currency,
            rate: data.rate ?? 0
        )

        let transferViewModel = TransferViewViewModel(
            senderViewViewModel: senderExchangeViewModel,
            receiverViewViewModel: receiverExchangeViewModel,
            exchangeRateViewViewModel: exchangeRateViewViewModel
        )

        transferView.configure(transferViewModel)
    }

    private func showSearchViewController(_ context: SearchViewModel.Context) {
        let searchViewModel = SearchViewModel(context)
        let searchViewController = SearchViewController(searchViewModel)

        let navigationController = UINavigationController(rootViewController: searchViewController)
        navigationController.navigationBar.backgroundColor = .white
        navigationController.navigationBar.prefersLargeTitles = true

        present(navigationController, animated: true)
    }
}
