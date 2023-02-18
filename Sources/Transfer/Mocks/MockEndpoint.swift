//
//  File.swift
//  
//
//  Created by Vitalii Kizlov on 18.02.2023.
//

import Foundation

enum MockEndpoint: RequestProviding {
    case mock(ExchangeRateParameters)

    var path: String {
        return "/rates"
    }

    var method: HTTPMethod {
        return .get
    }

    var parameters: [String : Any] {
        switch self {
        case .mock(let params):
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
