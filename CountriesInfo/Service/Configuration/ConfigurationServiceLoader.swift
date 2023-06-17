//
//  ConfigurationServiceLoader.swift
//  CountriesInfo
//
//  Created by Alexander Dovlatov on 6/17/23.
//

import Foundation

/// The configuration loader
protocol ConfigurationServiceLoader {
    /// Load the configuration
    func load(completion: @escaping (Result<ApplicationConfiguration, Error>) -> Void)
}
