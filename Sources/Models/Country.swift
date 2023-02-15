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
