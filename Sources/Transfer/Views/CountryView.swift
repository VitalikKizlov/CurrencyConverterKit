//
//  File.swift
//  
//
//  Created by Vitalii Kizlov on 14.02.2023.
//

import UIKit
import Utilities

public final class CountryView: UIView {

    @AutoLayoutable private var imageView = UIImageView()
    @AutoLayoutable private var titleLabel = UILabel()

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
        imageView.contentMode = .scaleAspectFit
        titleLabel.numberOfLines = 1
    }

    private func addSubviews() {
        addSubview(imageView)
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 24),
            imageView.heightAnchor.constraint(equalToConstant: 24),

            titleLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(greaterThanOrEqualTo: trailingAnchor)
        ])
    }

    // MARK: - Public

    public func configure(_ viewModel: CountryViewViewModel) {
        imageView.image = viewModel.image
        titleLabel.text = viewModel.title
    }
}

public struct CountryViewViewModel {
    public let image: UIImage
    public let title: String

    public init(image: UIImage, title: String) {
        self.image = image
        self.title = title
    }
}
