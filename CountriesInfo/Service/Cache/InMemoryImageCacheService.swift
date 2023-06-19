//
//  InMemoryImageCacheService.swift
//  CountriesInfo
//
//  Created by Alexander Dovlatov on 6/17/23.
//

import Foundation
import UIKit

/// The basic in-memory cache
final class InMemoryImageCacheService: ImageCacheService {
    private var cache: [Key: Element] = [:]

    func getElement(for key: String) -> UIImage? {
        return cache[key]
    }

    func setElement(_ element: UIImage, for key: String) {
        cache[key] = element
    }
}
