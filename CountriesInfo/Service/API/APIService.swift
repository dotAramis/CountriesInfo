//
//  APIService.swift
//  CountriesInfo
//
//  Created by Alexander Dovlatov on 6/16/23.
//

import Foundation
import Combine

protocol APIService: AnyObject {
    var configuration: APIConfiguration { get set }
    func resolveEndpoint(_ endpoint: ResourceEndpoint, configuration: APIConfiguration) -> URL
    func fetchJSON<T: Decodable>(endpoint: ResourceEndpoint, type: T.Type, completion: @escaping (Result<T,Error>) -> Void) -> URLSessionDataTask
    func fetchJSONPublisher<T: Decodable>(endpoint: ResourceEndpoint, type: T.Type) -> AnyPublisher<T, any Error>
    func fetchData(endpoint: ResourceEndpoint, completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionDataTask
    func fetchDataPublisher(endpoint: ResourceEndpoint) -> AnyPublisher<Data, any Error>
}

extension APIService {
    /// Makes the Data Task to fetch and decode the data from the endpoint
    /// - Parameters:
    ///   - endpoint: The target endpoint
    ///   - type: The response type
    ///   - completion: The result closure
    /// - Returns: The fetch `URLSessionDataTask`
    func fetchJSON<T: Decodable>(endpoint: ResourceEndpoint, type: T.Type, completion: @escaping (Result<T,Error>) -> Void) -> URLSessionDataTask {
        return base_fetchJSON(endpoint: endpoint, type: type, completion: completion)
    }

    /// The fetch publisher
    /// - Parameters:
    ///   - endpoint: The target endpoint
    ///   - type: The response type
    /// - Returns: The publisher
    func fetchJSONPublisher<T>(endpoint: ResourceEndpoint, type: T.Type) -> AnyPublisher<T, Error> where T : Decodable {
        return base_fetchJSONPublisher(endpoint: endpoint, type: type)
    }

    /// Makes the Data Task to fetch the data from the endpoint
    /// - Parameters:
    ///   - endpoint: The target endpoint
    ///   - type: The response type
    ///   - completion: The result closure
    /// - Returns: The fetch `URLSessionDataTask`
    func fetchData(endpoint: ResourceEndpoint, completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionDataTask {
        return base_fetchData(endpoint: endpoint, completion: completion)
    }

    /// The fetch publisher
    /// - Parameters:
    ///   - endpoint: The target endpoint
    ///   - type: The response type
    /// - Returns: The publisher
    func fetchDataPublisher(endpoint: ResourceEndpoint) -> AnyPublisher<Data, Error> {
        return base_fetchDataPublisher(endpoint: endpoint)
    }


    /// Makes the Data Task to fetch and decode the data from the endpoint
    /// - Parameters:
    ///   - endpoint: The target endpoint
    ///   - type: The response type
    ///   - completion: The result closure
    /// - Returns: The fetch `URLSessionDataTask`
    func base_fetchJSON<T: Decodable>(endpoint: ResourceEndpoint, type: T.Type, completion: @escaping (Result<T,Error>) -> Void) -> URLSessionDataTask {
        let url = resolveEndpoint(endpoint, configuration: configuration)
        let request = URLRequest(url: url)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200 ..< 300) ~= httpResponse.statusCode,
                  let data = data else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }

            // For the real API this should be here:
            // guard httpResponse.mimeType == "application/json" else {
            //     completion(.failure(URLError(.badServerResponse)))
            //     return
            // }

            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }

        return task
    }

    /// Makes the Data Task to fetch the data from the endpoint
    /// - Parameters:
    ///   - endpoint: The target endpoint
    ///   - type: The response type
    ///   - completion: The result closure
    /// - Returns: The fetch `URLSessionDataTask`
    func base_fetchData(endpoint: ResourceEndpoint, completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionDataTask {
        let url = resolveEndpoint(endpoint, configuration: configuration)
        let request = URLRequest(url: url)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200 ..< 300) ~= httpResponse.statusCode,
                  let data = data else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            completion(.success(data))
        }

        return task
    }

    /// The fetch publisher
    /// - Parameters:
    ///   - endpoint: The target endpoint
    ///   - type: The response type
    /// - Returns: The publisher
    func base_fetchJSONPublisher<T: Decodable>(endpoint: ResourceEndpoint, type: T.Type) -> AnyPublisher<T, any Error> {
        return fetchDataPublisher(endpoint: endpoint)
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    /// The fetch publisher
    /// - Parameters:
    ///   - endpoint: The target endpoint
    ///   - type: The response type
    /// - Returns: The publisher
    func base_fetchDataPublisher(endpoint: ResourceEndpoint) -> AnyPublisher<Data, any Error> {
        return Just((endpoint, configuration))
            .map(resolveEndpoint(_:configuration:))
            .flatMap{ URLSession.shared.dataTaskPublisher(for: $0) }
            .tryMap { (data, response) -> Data in
                guard let httpResponse = response as? HTTPURLResponse else { throw URLError(.badServerResponse) }
                guard (200 ..< 300) ~= httpResponse.statusCode else { throw URLError(.badServerResponse) }
                // For the real API this should be here:
                // guard httpResponse.mimeType == "application/json" else { throw URLError(.badServerResponse) }
                return data

            }.eraseToAnyPublisher()
    }
}

extension APIService {

}
