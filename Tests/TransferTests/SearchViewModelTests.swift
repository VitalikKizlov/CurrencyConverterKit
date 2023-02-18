//
//  File.swift
//  
//
//  Created by Vitalii Kizlov on 18.02.2023.
//

import XCTest
@testable import Transfer

class SearchViewModelTests: XCTestCase {

    private var sut: SearchViewModel!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = SearchViewModel(.sender)
    }

    override func tearDownWithError() throws {
        sut = .none
        try super.tearDownWithError()
    }

    func testViewInputEvents() {
        sut = SearchViewModel(.sender)

        sut.viewInputEvent.send(.cancelButtonClicked)
        XCTAssertEqual(sut.state, SearchViewModel.LoadingState.loaded([]))

        sut.viewInputEvent.send(.textDidChange("uk"))
        XCTAssertEqual(sut.searchText, "uk")

        sut.viewInputEvent.send(.textDidChange(""))
        XCTAssertEqual(sut.state, SearchViewModel.LoadingState.loaded([]))
    }
}
