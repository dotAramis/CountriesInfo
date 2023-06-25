//
//  SVGImageCacheService.swift
//  CountriesInfo
//
//  Created by Alexander Dovlatov on 6/24/23.
//

import Foundation

/// The SVG Image Cache service
protocol SVGImageCacheService: CacheService where Element == Data, Key == String { }

extension InMemoryCacheService: SVGImageCacheService where Element == Data, Key == String {}
