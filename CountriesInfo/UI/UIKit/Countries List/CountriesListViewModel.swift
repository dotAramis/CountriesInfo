//
//  CountriesListViewModel.swift
//  CountriesInfo
//
//  Created by Alexander Dovlatov on 6/17/23.
//

import Foundation
import UIKit

/// The Countries list View Model
final class CountriesListViewModel {
    typealias ActionPublisher = (Action) -> Void
    /// The Action Publisher
    var actionPublisher: ActionPublisher?

    /// The Data Task used to fetch the data
    private weak var dataTask: URLSessionDataTask?

    /// The State
    var state: State = .initial {
        didSet { actionPublisher?(.updateState(state)) } // Notify the publisher on the state change
    }

    /// The filtered items list
    private(set) var filteredCountries: [Country] = [] {
        didSet {
            // Update the Table View on every `filteredItems` update
            var snapshot = NSDiffableDataSourceSnapshot<CountriesListViewController.Section, Country>()
            snapshot.appendSections([CountriesListViewController.Section.countries])
            snapshot.appendItems(filteredCountries)
            actionPublisher?(.updateCountries(snapshot))
        }
    }

    /// The search text for filtering
    var searchText: String? {
        didSet { updateItems() }
    }

    /// The list of all items fetched
    private var countries: [Country] = [] {
        didSet { updateItems() }
    }

    /// Updates the filtered items based on the items list and the search text
    private func updateItems() {
        guard let searchPattern = searchText?.lowercased(), searchPattern.count > 0 else {
            filteredCountries = countries
            return
        }
        filteredCountries = countries.filter({ country in
            country.name.lowercased().contains(searchPattern) || country.capital.lowercased().contains(searchPattern)
        })
    }

    /// Fetched the data
    func fetch() {
        dataTask?.cancel()
        state = .loading
        let task = APP.apiService.fetchJSON(endpoint: ResourceEndpoint.countries,
                                            type: [CountryDTO].self) { [weak self] result in
            switch result {
            case .success(let dtoItems):
                do {
                    self?.countries = try dtoItems.map {try Country(dto: $0)}
                    self?.state = .loaded
                } catch {
                    self?.state = .failure(error)
                }
            case .failure(let error): self?.state = .failure(error)
            }
        }
        self.dataTask = task
        task.resume()
    }
}

extension CountriesListViewModel {
    /// The View Model State
    enum State {
        case initial
        case loading
        case loaded
        case failure(Error)
    }
}

extension CountriesListViewModel {
    /// Actions that are published to the view
    enum Action {
        /// Updates the state
        case updateState(State)
        /// Updates the Table View DataSource
        case updateCountries(NSDiffableDataSourceSnapshot<CountriesListViewController.Section, Country>)
    }
}
