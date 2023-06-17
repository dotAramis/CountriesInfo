//
//  NavigationState.swift
//  CountriesInfo
//
//  Created by Alexander Dovlatov on 6/18/23.
//

import Foundation

/// The app navigation State
final class NavigationState: ObservableObject {
    @Published var selectedFlow: RootViewModel.Flow?
    func closeFlow() {
        APP.navigationState.selectedFlow = nil
    }
}
