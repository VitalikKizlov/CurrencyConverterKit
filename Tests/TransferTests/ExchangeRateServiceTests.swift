//
//  File.swift
//  
//
//  Created by Vitalii Kizlov on 18.02.2023.
//

import XCTest
@testable import Transfer
import Combine

class ExchangeRateServiceTests: XCTestCase {

    @Injected(\.exchangeRateService) private var exchangeRateService: ExchangeRateServiceProtocol
    private var subscriptions: Set<AnyCancellable> = []

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func testChangeReceiverAmount() {
        exchangeRateService.changeReceiverAmount(500)

        XCTAssertEqual(exchangeRateService.exchangeData?.receiver.amount, 500)
    }

    func testSwap() {
        exchangeRateService.performCurrenciesSwap()

        XCTAssertEqual(exchangeRateService.exchangeData?.sender.country.currency, Currency(rawValue: "UAH"))
        XCTAssertEqual(exchangeRateService.exchangeData?.receiver.country.currency, Currency(rawValue: "PLN"))
    }

    func testValidateSenderAmount() {
        var isValid = true
        let expectation = self.expectation(description: "isValid")

        exchangeRateService.isAmountValidPublisher
            .sink { params in
                isValid = params.isValid
                expectation.fulfill()
            }
            .store(in: &subscriptions)

        exchangeRateService.validateSenderAmount(300000)

        waitForExpectations(timeout: 5)

        XCTAssertEqual(false, isValid)
    }
}

