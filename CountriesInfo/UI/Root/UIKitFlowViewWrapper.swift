//
//  UIKitFlowViewWrapper.swift
//  CountriesInfo
//
//  Created by Alexander Dovlatov on 6/18/23.
//

import Foundation
import SwiftUI

/// The wrapper to present the UIKit Flow
struct UIKitFlowViewWrapper: UIViewControllerRepresentable {
    typealias UIViewControllerType = UINavigationController
    func makeUIViewController(context: Context) -> UIViewControllerType {
        let viewController = UINavigationController(rootViewController: CountriesListViewController())
        viewController.navigationBar.prefersLargeTitles = true
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

    }
}
