//
//  LocalizationsTests.swift
//  CountriesInfoTests
//
//  Created by Alexander Dovlatov on 6/18/23.
//

import Foundation
import XCTest
@testable import CountriesInfo

final class LocalizationsTests: XCTestCase {
    func testCurrentLocalization() throws {
        for key in LocalizationKeys.allCases {
            XCTAssertNotEqual(key.rawValue, key.localizedValue())
        }
    }
}
