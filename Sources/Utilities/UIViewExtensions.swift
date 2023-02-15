//
//  File.swift
//  
//
//  Created by Vitalii Kizlov on 14.02.2023.
//

import UIKit

extension UIView {
    public func constraintsForAnchoringTo(boundsOf view: UIView, padding: CGFloat = 0.0) -> [NSLayoutConstraint] {
        [
            topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
        ]
    }
}
