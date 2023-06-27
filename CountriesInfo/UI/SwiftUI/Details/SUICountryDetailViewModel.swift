//
//  SUICountryDetailViewModel.swift
//  CountriesInfo
//
//  Created by Alexander Dovlatov on 6/18/23.
//

import Foundation
import SwiftUI
import Combine

final class SUICountryDetailViewModel: ObservableObject {
    let country: Country

    @Published var flagPlaceholderData: Data?
    /// The flag image data
    @Published var flagData: Data?
    /// The flag state
    @Published var flagState: FlagState = .initial

    private var bag: Set<AnyCancellable> = Set()

    init(country: Country) {
        self.country = country
        if let url = Bundle.main.url(forResource: "usa.flag", withExtension: "svg"),
           let data = try? Data(contentsOf: url) {
            self.flagPlaceholderData = data
        }
    }

    /// Fetches the flag
    func loadFlag() {
        guard case .initial = flagState else { return }

        flagState = .loading
        APP.apiService
            .fetchDataPublisher(endpoint: .custom(country.flagImageURL))
            .receive(on: RunLoop.main)
            .sink { [unowned self] completion in
                switch completion {
                case .finished:
                    flagState = .loaded
                case .failure(let error):
                    flagState = .failure(error)
                }
            } receiveValue: { [unowned self] data in
                self.flagData = data
            }
            .store(in: &bag)
    }
}

extension SUICountryDetailViewModel {
    /// The flag State
    enum FlagState {
        case initial
        case loading
        case failure(Error)
        case loaded
    }
}
