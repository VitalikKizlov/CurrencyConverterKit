//
//  File.swift
//  
//
//  Created by Vitalii Kizlov on 20.02.2023.
//

import XCTest
@testable import Transfer

class CurrencyExchangeViewControllerTests: XCTestCase {

    private var sut: CurrencyExchangeViewController!
    private var viewModel: CurrencyExchangeViewModel!

    override func setUpWithError() throws {
        try super.setUpWithError()
        viewModel = CurrencyExchangeViewModel()
        sut = CurrencyExchangeViewController(viewModel)
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        sut = .none
        viewModel = .none
        try super.tearDownWithError()
    }

    func testViewControllerInitializing() {
        viewModel = CurrencyExchangeViewModel()
        sut = CurrencyExchangeViewController(viewModel)
        XCTAssertNotNil(viewModel)
        XCTAssertNotNil(sut)
    }
}
