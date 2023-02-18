//
//  File.swift
//  
//
//  Created by Vitalii Kizlov on 18.02.2023.
//

import XCTest
@testable import Transfer

class SearchViewControllerTests: XCTestCase {

    private var sut: SearchViewController!
    private var viewModel: SearchViewModel!

    override func setUpWithError() throws {
        try super.setUpWithError()
        viewModel = SearchViewModel(.sender)
        sut = SearchViewController(viewModel)
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        sut = .none
        viewModel = .none
        try super.tearDownWithError()
    }

    func testViewControllerInitializing() {
        viewModel = SearchViewModel(.sender)
        sut = SearchViewController(viewModel)
        XCTAssertNotNil(viewModel)
        XCTAssertNotNil(sut)
    }
}
