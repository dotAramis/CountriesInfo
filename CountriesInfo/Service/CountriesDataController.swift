//
//  CountriesDataController.swift
//  CountriesInfo
//
//  Created by Alexander Dovlatov on 6/17/23.
//

import Foundation
import Combine

/// The Countries Data Controller
final class CountriesDataController {
    /// The state
    @Published var state: DataControllerState = .ready
    /// The countries fetched so far
    @Published var countries: [Country] = []

    /// Stores the fetch subscription
    private var _subscription: AnyCancellable?

    /// Fetches the list
    func fetchList() {
        _subscription?.cancel()

        self.state = .loading
        _subscription = ApplicationContext.shared.apiService
            .fetchCountriesPublisher()
            .eraseToAnyPublisher()
            .sink { [unowned self] completion in
                switch completion {
                case .finished: self.state = .loaded
                case .failure(let error): self.state = .failure(error)
                }
            } receiveValue: { [unowned self] countries in
                self.countries = countries
            }
    }
}
