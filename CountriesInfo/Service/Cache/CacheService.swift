//
//  CacheService.swift
//  CountriesInfo
//
//  Created by Alexander Dovlatov on 6/16/23.
//

import Foundation

/// The generic Cache Service
protocol CacheService {
    associatedtype Element
    associatedtype Key: Hashable

    /// Sets the Element fot the Key
    /// - Parameters:
    ///   - element: The element to cache
    ///   - key: The key
    func setElement(_ element: Element, for key: Key)
    /// Gets the element by the Key
    /// - Parameter key: The key
    /// - Returns: The element if it exists or `nil`
    func getElement(for key: Key) -> Element?
}
