//
//  APIService+countries.swift
//  CountriesInfo
//
//  Created by Alexander Dovlatov on 6/16/23.
//

import Foundation
import Combine

extension APIService {
    /// The convenience method to construct the `ResourceEndpoint.countries` request publisher
    func fetchCountriesPublisher() -> AnyPublisher<[Country], any Error> {
        return self.fetchJSONPublisher(endpoint: ResourceEndpoint.countries, type: [CountryDTO].self)
            .tryMap { dtos in
                return try dtos.map { try Country(dto: $0) }
            }
            .eraseToAnyPublisher()
    }
}
