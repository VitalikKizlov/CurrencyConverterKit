//
//  File.swift
//  
//
//  Created by Vitalii Kizlov on 15.02.2023.
//

import UIKit

public struct Country {
    public let image: UIImage
    public let currency: Currency

    public init(image: UIImage, currency: Currency) {
        self.image = image
        self.currency = currency
    }
}

public extension Country {
    static let poland = Country(image: UIImage(named: "pol", in: .module, with: nil)!, currency: .pln)
    static let ukraine = Country(image: UIImage(named: "ukr", in: .module, with: nil)!, currency: .uah)
    static let germany = Country(image: UIImage(named: "ger", in: .module, with: nil)!, currency: .eur)
    static let greatBritain = Country(image: UIImage(named: "gbp", in: .module, with: nil)!, currency: .gbp)
}

extension Country: Hashable, Equatable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(image)
        hasher.combine(currency)
    }

    public static func == (lhs: Country, rhs: Country) -> Bool {
        return lhs.image == rhs.image && lhs.currency == rhs.currency
    }
}
