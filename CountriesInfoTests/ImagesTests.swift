//
//  ImagesTests.swift
//  CountriesInfoTests
//
//  Created by Alexander Dovlatov on 6/18/23.
//

import Foundation
import XCTest
@testable import CountriesInfo

final class ImagesTests: XCTestCase {
    func testImagesExists() throws {
        for key in ImageName.allCases {
            XCTAssertNotNil(key.uiImage())
        }
    }
}
