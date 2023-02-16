//
//  SearchEndpoint.swift
//  TransferGoTest
//
//  Created by Vitalii Kizlov on 11.02.2023.
//

import Foundation

enum ExchangeRateEnpoint: RequestProviding {

    case exchangeRates(ExchangeRateParameters)

    var path: String {
        return "/api/fx-rates"
    }

    var method: HTTPMethod {
        return .get
    }

    var parameters: [String : Any] {
        switch self {
        case .exchangeRates(let params):
            return [
                "from": params.from,
                "to": params.to,
                "amount": params.amount
            ]
        }
    }

    var headerFields: [String : String] {
        return [:]
    }
}
