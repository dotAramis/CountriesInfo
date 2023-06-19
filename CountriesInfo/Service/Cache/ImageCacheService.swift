//
//  ImageCacheService.swift
//  CountriesInfo
//
//  Created by Alexander Dovlatov on 6/17/23.
//

import Foundation
import UIKit

/// The UIImage Cache service
protocol ImageCacheService: CacheService where Element == UIImage, Key == String {
}
