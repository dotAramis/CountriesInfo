//
//  DataControllerState.swift
//  CountriesInfo
//
//  Created by Alexander Dovlatov on 6/17/23.
//

import Foundation

/// The Data Controller State
enum DataControllerState {
    case ready
    case loading
    case loaded
    case failure(Error)
}
