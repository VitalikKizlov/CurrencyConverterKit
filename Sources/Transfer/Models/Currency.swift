//
//  File.swift
//  
//
//  Created by Vitalii Kizlov on 15.02.2023.
//

import Foundation

public enum Currency: String, Codable {
    case pln = "PLN"
    case uah = "UAH"
    case eur = "EUR"
    case gbp = "GBP"

    var title: String {
        switch self {
        case .pln:
            return "Zloty • \(self.rawValue)"
        case .uah:
            return "Hrivna • \(self.rawValue)"
        case .eur:
            return "Euro • \(self.rawValue)"
        case .gbp:
            return "British Pound • \(self.rawValue)"
        }
    }
}
