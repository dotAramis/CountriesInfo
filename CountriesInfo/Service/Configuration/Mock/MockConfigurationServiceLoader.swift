//
//  MockConfigurationServiceLoader.swift
//  CountriesInfo
//
//  Created by Alexander Dovlatov on 6/17/23.
//

import Foundation

/// The mock configuration service loader
final class MockConfigurationServiceLoader: ConfigurationServiceLoader {
    init(environment: ApplicationEnvironment) {
        self.environment = environment
    }

    /// The application environment
    let environment: ApplicationEnvironment

    func load(completion: @escaping (Result<ApplicationConfiguration, Error>) -> Void) {
        do {
            let configuration = try ApplicationConfiguration.loadFromBundle(environment: environment)
            DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 1) {
                completion(.success(configuration))
            }
        } catch {
            completion(.failure(error))
        }
    }
}
