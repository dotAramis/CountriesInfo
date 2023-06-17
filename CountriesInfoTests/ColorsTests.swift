//
//  ColorsTests.swift
//  CountriesInfoTests
//
//  Created by Alexander Dovlatov on 6/18/23.
//

import Foundation
import XCTest
@testable import CountriesInfo

final class ColorsTests: XCTestCase {
    func testColorsExists() throws {
        for key in ColorName.allCases {
            XCTAssertNotNil(key.uiColor())
            XCTAssertNotNil(key.suiColor())
        }
    }
}
