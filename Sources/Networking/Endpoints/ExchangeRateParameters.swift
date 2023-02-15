//
//  SearchParameters.swift
//  TransferGoTest
//
//  Created by Vitalii Kizlov on 11.02.2023.
//

import Foundation

public struct ExchangeRateParameters {
    let from: String
    let to: String
    let amount: Double

    public init(from: String, to: String, amount: Double) {
        self.from = from
        self.to = to
        self.amount = amount
    }
}
