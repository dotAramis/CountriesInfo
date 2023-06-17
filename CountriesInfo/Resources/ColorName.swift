//
//  ColorName.swift
//  CountriesInfo
//
//  Created by Alexander Dovlatov on 6/17/23.
//

import Foundation
import UIKit
import SwiftUI

/// The names of all colors in the app, defined in `Assets.xcassets`
/// Very testable
/// ```
/// let uiColor: UIColor? = ColorName.commonBackground.uiColor()
/// let suiColor: Color = ColorName.commonBackground.suiColor()
/// ```
enum ColorName: String, CaseIterable {
    case commonBackground = "Colors/Common/background"
    case buttonBackground = "Colors/Common/buttonBackground"
    case commonCaptionText = "Colors/Common/captionTextColor"
    case commonText = "Colors/Common/textColor"
    case buttonText = "Colors/Common/buttonTextColor"
    case selectedBackground = "Colors/Common/selectedBackground"
    case loader = "Colors/Common/loader"
}

extension ColorName {
    /// Convenience var for the name
    var colorName: String { return rawValue }
}

extension ColorName {
    /// UIKit UIColor
    func uiColor() -> UIColor? {
        return UIColor(named: colorName)
    }

    /// SwiftUI Color
    func suiColor() -> Color {
        return Color(colorName)
    }
}
