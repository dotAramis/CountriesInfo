//
//  SUICountryDetailViewModel.swift
//  CountriesInfo
//
//  Created by Alexander Dovlatov on 6/18/23.
//

import Foundation
import SwiftUI
import Combine
import SVGKit

final class SUICountryDetailViewModel: ObservableObject {
    let country: Country
    /// The flag image
    @Published var image: Image?
    /// The flag state
    @Published var flagState: FlagState = .initial

    private var bag: Set<AnyCancellable> = Set()

    init(country: Country) {
        self.country = country
    }

    /// Fetches the flag
    func loadFlag() {
        flagState = .loading
        APP.apiService
            .fetchDataPublisher(endpoint: .custom(country.flagImageURL))
            .tryMap { data -> SVGKImage in
                guard let image = SVGKImage(data: data) else {
                    throw URLError(.badServerResponse)
                }
                return image
            }
            .map { svgImage -> UIImage in
                if svgImage.hasSize() {
                    svgImage.size = CGSize(width: 300, height: 200)
                    return svgImage.uiImage
                } else {
                    return svgImage.uiImage
                }
            }
            .map {Image(uiImage: $0)}
            .receive(on: RunLoop.main)
            .sink { [unowned self] completion in
                switch completion {
                case .finished:
                    flagState = .loaded
                case .failure(let error):
                    flagState = .failure(error)
                }
            } receiveValue: { [unowned self] flagImage in
                self.image = flagImage
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
