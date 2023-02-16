//
//  SearchCollectionViewCellView.swift
//  ArgyleTest
//
//  Created by Vitalii Kizlov on 11.02.2023.
//

import UIKit
import Utilities

final class SearchCollectionViewCellView: UIView {

    @AutoLayoutable private var imageView = UIImageView()
    @AutoLayoutable private var titleLabel = UILabel()
    @AutoLayoutable private var subTitleLabel = UILabel()
    @AutoLayoutable private var labelsStackView = UIStackView()

    private let companyLogoSize = CGSize(width: 50, height: 50)

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
        setupCompanyLogo()
        setupLabels()
        setupLabelsStackView()
    }

    private func setupCompanyLogo() {
        imageView.contentMode = .scaleAspectFit
    }

    private func setupLabels() {
        titleLabel.numberOfLines = 1
        subTitleLabel.numberOfLines = 1
    }

    private func setupLabelsStackView() {
        labelsStackView.addArrangedSubview(titleLabel)
        labelsStackView.addArrangedSubview(subTitleLabel)
        labelsStackView.axis = .vertical
        labelsStackView.spacing = 4.0
        labelsStackView.alignment = .leading
    }

    private func addSubviews() {
        addSubview(imageView)
        addSubview(labelsStackView)

        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: companyLogoSize.width),
            imageView.heightAnchor.constraint(equalToConstant: companyLogoSize.height),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),

            labelsStackView.topAnchor.constraint(equalTo: imageView.topAnchor),
            labelsStackView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            labelsStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            labelsStackView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor)
        ])
    }

    func setup(_ viewModel: SearchItemViewModel) {
        titleLabel.text = viewModel.title
        subTitleLabel.text = viewModel.subtitle
        imageView.image = viewModel.image
    }
}
