//
//  File.swift
//  
//
//  Created by Vitalii Kizlov on 14.02.2023.
//

import Foundation

public struct ExchangeRateData: Codable {
    public let from: String
    public let to: String
    public let rate: Double
    public let fromAmount: Double
    public let toAmount: Double
}
