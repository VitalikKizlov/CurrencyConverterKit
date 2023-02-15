//
//  File.swift
//  
//
//  Created by Vitalii Kizlov on 14.02.2023.
//

import UIKit
import Utilities

public final class ExchangeDataView: UIView {

    @AutoLayoutable private var titleLabel = UILabel()
    @AutoLayoutable private var countryView = CountryView()
    @AutoLayoutable private var textfield = UITextField()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        addSubviews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private

    private func setupSubviews() {
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 0.2
        
        titleLabel.numberOfLines = 1
        textfield.keyboardType = .decimalPad
        textfield.textAlignment = .right
        textfield.font = UIFont.systemFont(ofSize: 32, weight: .medium)
    }

    private func addSubviews() {
        addSubview(titleLabel)
        addSubview(countryView)
        addSubview(textfield)

        textfield.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: textfield.leadingAnchor, constant: -16),

            countryView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            countryView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            countryView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),

            textfield.centerYAnchor.constraint(equalTo: centerYAnchor),
            textfield.leadingAnchor.constraint(equalTo: countryView.trailingAnchor, constant: 8),
            textfield.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            textfield.heightAnchor.constraint(equalToConstant: 36)
        ])
    }

    // MARK: - Configure

    public func configure(_ viewModel: ExchangeDataViewViewModel) {
        titleLabel.text = viewModel.title
        textfield.text = "\(viewModel.amount)"

        countryView.configure(viewModel.countryViewViewModel)
    }
}

public struct ExchangeDataViewViewModel {
    public let title: String
    public let countryViewViewModel: CountryViewViewModel
    public let amount: Double

    public init(title: String, countryViewViewModel: CountryViewViewModel, amount: Double) {
        self.title = title
        self.countryViewViewModel = countryViewViewModel
        self.amount = amount
    }
}
