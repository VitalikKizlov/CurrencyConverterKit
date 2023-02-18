//
//  ExchangeRateProvider.swift
//  
//
//  Created by Vitalii Kizlov on 18.02.2023.
//

import XCTest
@testable import Transfer
import Combine

final class ExchangeRateProvider: XCTestCase {

    @Injected(\.exchangeRateProvider) private var exchangeRateProvider: ExchangeRateProviding

    private var subscriptions: Set<AnyCancellable> = []

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func testSearchResponse() {
        let expectedResponse = ExchangeRateData(from: Currency(rawValue: "PLN")!, to: Currency(rawValue: "UAH")!, rate: 8.26103, fromAmount: 300, toAmount: 2478.31)

        let expectation = XCTestExpectation(description: "data")

        let parameters = ExchangeRateParameters(from: "PLN", to: "UAH", amount: 300)
        exchangeRateProvider.getExchangeRate(parameters)
            .sink(receiveCompletion: { _ in }) { response in
                XCTAssertEqual(response, expectedResponse)
                expectation.fulfill()
            }
            .store(in: &subscriptions)

        wait(for: [expectation], timeout: 1)
    }

}
