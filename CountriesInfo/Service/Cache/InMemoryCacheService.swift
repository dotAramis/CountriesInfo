//
//  InMemoryCacheService.swift
//  CountriesInfo
//
//  Created by Alexander Dovlatov on 6/17/23.
//

import Foundation
import UIKit

/// The basic in-memory cache
final class InMemoryCacheService<Key: Hashable, Element>: CacheService {
    private var cache: [Key: Element] = [:]

    func getElement(for key: Key) -> Element? {
        return cache[key]
    }

    func setElement(_ element: Element, for key: Key) {
        cache[key] = element
    }
}
