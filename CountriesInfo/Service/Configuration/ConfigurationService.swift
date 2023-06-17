//
//  ConfigurationService.swift
//  CountriesInfo
//
//  Created by Alexander Dovlatov on 6/17/23.
//

import Foundation

/// The configuration service
final class ConfigurationService {
    /// The configuration loader
    let loader: ConfigurationServiceLoader
    /// The application configuration
    @Published private(set) var configuration: ApplicationConfiguration

    init(loader: ConfigurationServiceLoader,
         environment: ApplicationEnvironment) throws {
        self.loader = loader
        self.configuration = try ApplicationConfiguration.loadFromBundle(environment: environment)
    }

    /// Updates the configuration
    func update(completion: ((Result<ApplicationConfiguration, Error>) -> Void)?) {
        loader.load { [weak self] result in
            switch result {
            case .success(let configuration):
                self?.configuration = configuration
            case .failure(let error):
                print("Error loading configuration: \(error)")
            }
            completion?(result)
        }
    }
}
