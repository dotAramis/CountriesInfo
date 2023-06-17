//
//  ApplicationConfiguration.swift
//  CountriesInfo
//
//  Created by Alexander Dovlatov on 6/17/23.
//

import Foundation

/// The main Application configuration
struct ApplicationConfiguration: Decodable {
    /// The API configuration
    let API: APIConfiguration

    /// Loads the configuration from bundle plist file
    /// The file name is based on the `environment`, `ApplicationConfiguration_{environment}.plist`
    static func loadFromBundle(environment: ApplicationEnvironment) throws -> ApplicationConfiguration {
        guard let url = Bundle.main.url(forResource: "ApplicationConfiguration_\(environment.name)", withExtension: "plist") else { throw URLError(.badURL) }
        let data = try Data(contentsOf: url)
        return try PropertyListDecoder().decode(ApplicationConfiguration.self, from: data)
    }
}
