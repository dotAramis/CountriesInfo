//
//  UIImageCacheService.swift
//  CountriesInfo
//
//  Created by Alexander Dovlatov on 6/24/23.
//

import Foundation
import UIKit

/// The SVG Image Cache service
protocol UIImageCacheService: CacheService where Element == UIImage, Key == String { }

extension InMemoryCacheService: UIImageCacheService where Element == UIImage, Key == String {}
