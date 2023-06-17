//
//  UIView+setIsHidden.swift
//  CountriesInfo
//
//  Created by Alexander Dovlatov on 6/17/23.
//

import UIKit
extension UIView {
    /// This helps to avoid an unblalanced update bug on `UIStackView`
    func setIsHidden(_ value: Bool) {
        guard isHidden != value else { return }
        isHidden = value
    }
}
