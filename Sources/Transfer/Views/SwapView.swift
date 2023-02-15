//
//  File.swift
//  
//
//  Created by Vitalii Kizlov on 14.02.2023.
//

import UIKit
import Utilities

public final class SwapView: UIView {

    @AutoLayoutable private var imageView = UIImageView()
    let tapGesture = UITapGestureRecognizer()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .blue
        imageView.image = UIImage(systemName: "arrow.swap")?.withTintColor(.white, renderingMode: .alwaysOriginal)

        addGestureRecognizer(tapGesture)

        addSubviews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }

    // MARK: - Private

    private func addSubviews() {
        addSubview(imageView)

        let constraints = imageView.constraintsForAnchoringTo(boundsOf: self, padding: 4)
        NSLayoutConstraint.activate(constraints)
    }
}
