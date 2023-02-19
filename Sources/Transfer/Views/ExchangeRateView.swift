//
//  File.swift
//  
//
//  Created by Vitalii Kizlov on 19.02.2023.
//

import UIKit

public final class ExchangeRateView: UIView {

    @AutoLayoutable private var titleLabel = UILabel()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        setupSubviews()
        addSubviews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private

    private func setupSubviews() {
        titleLabel.numberOfLines = 1
        titleLabel.textColor = .white
    }

    private func addSubviews() {
        addSubview(titleLabel)

        let constraints = titleLabel.constraintsForAnchoringTo(boundsOf: self, padding: 4)
        NSLayoutConstraint.activate(constraints)
    }

    // MARK: - Configure

    public func configure(_ viewModel: ExchangeRateViewViewModel) {
        titleLabel.text = viewModel.title
    }
}

public struct ExchangeRateViewViewModel {
    public let fromCurrency: Currency
    public let toCurrency: Currency
    public let rate: Double

    public var title: String {
        return "1 \(fromCurrency.rawValue) ~ \(rate) \(toCurrency.rawValue)"
    }

    public init(
        fromCurrency: Currency,
        toCurrency: Currency,
        rate: Double
    ) {
        self.fromCurrency = fromCurrency
        self.toCurrency = toCurrency
        self.rate = rate
    }
}
