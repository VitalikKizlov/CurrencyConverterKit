//
//  File.swift
//  
//
//  Created by Vitalii Kizlov on 18.02.2023.
//

import XCTest
@testable import Transfer

final class MockEndpointTests: XCTestCase {
    let endpoint = MockEndpoint.mock(ExchangeRateParameters(from: "PLN", to: "UAH", amount: 300))

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func testRequestGeneration() {
        let request = endpoint.urlRequest()

        XCTAssertEqual(request.url?.host, API.backendURL)
        XCTAssertEqual(request.url?.path, endpoint.path)

        let limitParameterValue = request.url?.valueOfQueryParameter("from")
        XCTAssertEqual(limitParameterValue, "PLN")

        let toParameterValue = request.url?.valueOfQueryParameter("to")
        XCTAssertEqual(toParameterValue, "UAH")

        let amountParameterValue = request.url?.valueOfQueryParameter("amount")
        XCTAssertEqual(amountParameterValue, "300.0")

        XCTAssertEqual(request.httpMethod, HTTPMethod.get.rawValue)
    }
}
