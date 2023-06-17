//
//  CountryInfoCellModelTests.swift
//  CountriesInfoTests
//
//  Created by Alexander Dovlatov on 6/17/23.
//

import XCTest
@testable import CountriesInfo

final class CountryInfoCellModelTests: XCTestCase {
    let viewModel = CountryInfoCellModel()
    let country = Country(name: "name",
                          capital: "capital",
                          code: "code",
                          flagImageURL: URL(string: "https://restcountries.eu/data/usa.svg")!,
                          language: Language(code: "LC", name: "LN"),
                          currency: Currency(code: "CC", name: "CN", symbol: "CS"),
                          region: "region")
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testUpdateTextsAction() throws {
        let expectation = XCTestExpectation(description: "Receive an action")
        viewModel.actionPublisher = { [weak self] action in
            switch action {
            case .updateText(name: let name,
                             region: let region,
                             code: let code,
                             capital: let capital):
                XCTAssertEqual(name, self?.country.name)
                XCTAssertEqual(region, self?.country.region)
                XCTAssertEqual(code, self?.country.code)
                XCTAssertEqual(capital, self?.country.capital)
                expectation.fulfill()
            }
        }
        viewModel.setup(with: country)
        wait(for: [expectation], timeout: 1.0)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
