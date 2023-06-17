//
//  CountriesListViewModelTests.swift
//  CountriesInfoTests
//
//  Created by Alexander Dovlatov on 6/17/23.
//

import Foundation

import XCTest
@testable import CountriesInfo

final class CountriesListViewModelTests: XCTestCase {
    let viewModel = CountriesListViewModel()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testUpdateTextsAction() throws {
        let expectation = XCTestExpectation(description: "Receive an action")


        wait(for: [expectation], timeout: 1.0)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
