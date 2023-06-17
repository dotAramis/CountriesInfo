//
//  ResourceEndpoint.swift
//  CountriesInfo
//
//  Created by Alexander Dovlatov on 6/16/23.
//

import Foundation

/// The storage for all application endpoints.
/// The URLs are constructed based on `APIConfiguration`
enum ResourceEndpoint {
    case countries

    case custom(URL)
}
