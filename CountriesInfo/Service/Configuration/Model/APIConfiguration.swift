//
//  APIConfiguration.swift
//  CountriesInfo
//
//  Created by Alexander Dovlatov on 6/17/23.
//

import Foundation

/// The API configuration
struct APIConfiguration: Decodable {
    /// The API base URL
    var baseURL: URL
    /// The countries request path
    var countriesPath: String

    /// The memberwise init, used for testing and mock data only
    init(baseURL: URL, countriesPath: String) {
        self.baseURL = baseURL
        self.countriesPath = countriesPath
    }

    // MARK: Decodable
    enum CodingKeys: CodingKey {
        case baseURL
        case countriesPath
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let baseURLString = try container.decode(String.self, forKey: .baseURL)
        guard let baseURL = URL(string: baseURLString) else { throw URLError(.badURL) }
        self.baseURL = baseURL
        self.countriesPath = try container.decode(String.self, forKey: .countriesPath)
    }
}
