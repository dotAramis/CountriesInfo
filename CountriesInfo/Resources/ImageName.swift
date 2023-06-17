//
//  ImageName.swift
//  CountriesInfo
//
//  Created by Alexander Dovlatov on 6/17/23.
//

import Foundation
import UIKit
import SwiftUI

/// The names of all bundle images in the app, stored in `Assets.xcassets`
/// Very testable
/// ```
/// let uiImage = ImageName.logo.uiImage()
/// ```
enum ImageName: String, CaseIterable {
    case logo = "logo"
}

extension ImageName {
    /// The convenience var for the name
    var imageName: String { return rawValue }
}

extension ImageName {
    /// Loads the UIImage by name
    func uiImage() -> UIImage? {
        return UIImage(named: self.imageName)
    }
}

extension Image {
    /// The convenience initializer
    init(_ imageName: ImageName) {
        self.init(imageName.imageName)
    }
}
