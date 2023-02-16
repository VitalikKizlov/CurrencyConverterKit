//
//  File.swift
//  
//
//  Created by Vitalii Kizlov on 15.02.2023.
//

import UIKit

public struct Country {
    public let name: String
    public let image: UIImage
    public let currency: Currency

    public init(name: String, image: UIImage, currency: Currency) {
        self.name = name
        self.image = image
        self.currency = currency
    }
}

public extension Country {
    static let poland = Country(name: "Poland", image: UIImage(named: "pol", in: .module, with: nil)!, currency: .pln)
    static let ukraine = Country(name: "Ukraine", image: UIImage(named: "ukr", in: .module, with: nil)!, currency: .uah)
    static let germany = Country(name: "Germany", image: UIImage(named: "ger", in: .module, with: nil)!, currency: .eur)
    static let greatBritain = Country(name: "Great Britain", image: UIImage(named: "gbp", in: .module, with: nil)!, currency: .gbp)
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
