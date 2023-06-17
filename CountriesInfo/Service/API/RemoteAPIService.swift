//
//  RemoteAPIService.swift
//  CountriesInfo
//
//  Created by Alexander Dovlatov on 6/17/23.
//

import Foundation
import Combine

final class RemoteAPIService: APIService {
    /// The current App configuration
    var configuration: APIConfiguration

    init(configuration: APIConfiguration) {
        self.configuration = configuration
    }

    /// Converts the endpoint to the URL based on the configuration
    func resolveEndpoint(_ endpoint: ResourceEndpoint, configuration: APIConfiguration) -> URL {
        switch endpoint {
        case .countries: return configuration.baseURL.appendingPathComponent(configuration.countriesPath)
        case .custom(let url): return url
        }
    }
}
