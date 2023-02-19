//
//  File.swift
//  
//
//  Created by Vitalii Kizlov on 19.02.2023.
//

import XCTest
@testable import Transfer

final class CountriesStoreServiceTests: XCTestCase {

    @Injected(\.countriesStoreService) private var countriesStoreService: CountriesStoreProtocol

    public override func setUpWithError() throws {
        try super.setUpWithError()
    }

    public override func tearDownWithError() throws {
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

    func testCountriesForReceiver() {
        let countries = countriesStoreService.countriesForReceiver()

        XCTAssertNotNil(countries)
    }

    func testCountriesForSenderDoesntContainReceiverCountry() {
        let countries = countriesStoreService.countriesForReceiver()
        let contains = countries.contains(where: { $0 == .ukraine })

        XCTAssertFalse(contains)
    }

    func testSenderCountry() {
        let country = countriesStoreService.senderCountry()

        XCTAssertEqual(country, .poland)
    }

    func testReceiverCountry() {
        let country = countriesStoreService.receiverCountry()

        XCTAssertEqual(country, .ukraine)
    }

    func testSenderCountryConfigurationOnSelection() {
        countriesStoreService.configureSenderCountry(for: "Germany")
        let country = countriesStoreService.senderCountry()

        XCTAssertEqual(country, .germany)
    }

    func testReceiverCountryConfigurationOnSelection() {
        countriesStoreService.configureReceiverCountry(for: "Great Britain")
        let country = countriesStoreService.receiverCountry()

        XCTAssertEqual(country, .greatBritain)
    }

}
