//
//  SearchCollectionViewCellViewModel.swift
//  ArgyleTest
//
//  Created by Vitalii Kizlov on 11.02.2023.
//

import Foundation
import UIKit

struct SearchItemViewModel {
    let title: String
    let subtitle: String
    let image: UIImage?
}

extension SearchItemViewModel: Hashable, Equatable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(subtitle)
        hasher.combine(image)
    }

    static func == (lhs: SearchItemViewModel, rhs: SearchItemViewModel) -> Bool {
        lhs.title == rhs.title && lhs.subtitle == rhs.subtitle && lhs.image == rhs.image
    }
}
