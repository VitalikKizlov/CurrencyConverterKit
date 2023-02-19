//
//  File.swift
//  
//
//  Created by Vitalii Kizlov on 19.02.2023.
//

import XCTest
@testable import Transfer

public final class CountriesStoreServiceTests: XCTestCase {

    @Injected(\.countriesStoreService) private var countriesStoreService: CountriesStoreProtocol

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func testCountriesForSender() {
        let countries = countriesStoreService.countriesForSender()

        XCTAssertNotNil(countries)
    }

    func testCountriesForSenderDoesntContainSenderCountry() {
        let countries = countriesStoreService.countriesForSender()
        let contains = countries.contains(where: { $0 == .poland })

        XCTAssertFalse(contains)
    }

}
