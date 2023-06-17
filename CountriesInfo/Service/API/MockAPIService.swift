//
//  MockAPIService.swift
//  CountriesInfo
//
//  Created by Alexander Dovlatov on 6/18/23.
//

import Foundation
import Combine

final class MockAPIService: APIService {
    var configuration: APIConfiguration = APIConfiguration(baseURL: Bundle.main.resourceURL!,
                                                           countriesPath: "mockCountries.json")

    /// Converts the endpoint to the URL based on the configuration
    func resolveEndpoint(_ endpoint: ResourceEndpoint, configuration: APIConfiguration) -> URL {
        switch endpoint {
        case .countries: return configuration.baseURL.appendingPathComponent(configuration.countriesPath)
        case .custom(let url):
            if url.absoluteString.contains("restcountries.eu") { // this is a flag
                return Bundle.main.url(forResource: "usa.flag", withExtension: "svg") ?? url
            }
            return configuration.baseURL.appending(component: url.lastPathComponent)
        }
    }

    func fetchDataPublisher(endpoint: ResourceEndpoint) -> AnyPublisher<Data, Error> {
        return Just((endpoint, configuration))
            .map(resolveEndpoint(_:configuration:))
            .flatMap{ URLSession.shared.dataTaskPublisher(for: $0) }
            .tryMap { (data, response) -> Data in
                return data
            }.eraseToAnyPublisher()
    }

    /// Makes the Data Task to fetch the data from the endpoint
    /// - Parameters:
    ///   - endpoint: The target endpoint
    ///   - type: The response type
    ///   - completion: The result closure
    /// - Returns: The fetch `URLSessionDataTask`
    func fetchData(endpoint: ResourceEndpoint, completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionDataTask {
        let url = resolveEndpoint(endpoint, configuration: configuration)
        let request = URLRequest(url: url)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            completion(.success(data))
        }

        return task
    }

    /// Makes the Data Task to fetch and decode the data from the endpoint
    /// - Parameters:
    ///   - endpoint: The target endpoint
    ///   - type: The response type
    ///   - completion: The result closure
    /// - Returns: The fetch `URLSessionDataTask`
    func fetchJSON<T>(endpoint: ResourceEndpoint, type: T.Type, completion: @escaping (Result<T, Error>) -> Void) -> URLSessionDataTask where T : Decodable {
        let url = resolveEndpoint(endpoint, configuration: configuration)
        let request = URLRequest(url: url)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }

            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 1) {
                    completion(.success(result))
                }
            } catch {
                completion(.failure(error))
            }
        }

        return task
    }

    /// The fetch publisher
    /// - Parameters:
    ///   - endpoint: The target endpoint
    ///   - type: The response type
    /// - Returns: The publisher
    func fetchJSONPublisher<T>(endpoint: ResourceEndpoint, type: T.Type) -> AnyPublisher<T, Error> where T : Decodable {
        return fetchDataPublisher(endpoint: endpoint)
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
