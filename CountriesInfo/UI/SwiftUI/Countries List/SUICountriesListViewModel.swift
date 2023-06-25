//
//  SUICountriesListViewModel.swift
//  CountriesInfo
//
//  Created by Alexander Dovlatov on 6/17/23.
//

import Foundation
import SwiftUI
import Combine

final class SUICountriesListViewModel: ObservableObject {
    /// The View Model State
    enum State {
        case initial
        case loading
        case loaded
        case failure(Error)
    }

    @Published var countries: [Country] = []
    @Published var filteredCountries: [Country] = []
    @Published var state: State = .initial
    @Published var searchText: String = ""
    @Published var selection: Country?
    /// The loader subscription. Cancellable.
    private var loadSubscription: AnyCancellable?
    private var bag: Set<AnyCancellable> = Set()

    /// Closes the whole flow
    func close() {
        APP.navigationState.closeFlow()
    }

    /// Fetches the list of Countries
    func fetch() {
        loadSubscription?.cancel()
        state = .loading
        loadSubscription = APP.apiService
            .fetchJSONPublisher(endpoint: ResourceEndpoint.countries, type: [CountryDTO].self)
            .tryMap{try $0.map{try Country(dto: $0)}}
            .receive(on: RunLoop.main)
            .sink { [unowned self] completion in
                switch completion {
                case .finished: break
                case .failure(let error): self.state = .failure(error)
                }
            } receiveValue: { [unowned self] countries in
                self.countries = countries
            }

        // Here we do filtering
        Publishers.CombineLatest($countries, $searchText)
            .debounce(for: 0.5, scheduler: RunLoop.main, options: .none)
            .map { countries, searchText in
                guard searchText.count > 0 else { return countries }
                let searchText = searchText.lowercased()
                let filtered = countries.filter { country in
                    country.name.lowercased().contains(searchText) || country.capital.lowercased().contains(searchText)
                }
                return filtered
            }
            .sink(receiveValue: { countries in
                withAnimation {
                    self.filteredCountries = countries
                    self.state = .loaded
                }
            })
            .store(in: &bag)
    }
}
