//
//  CountryDetailViewModel.swift
//  CountriesInfo
//
//  Created by Alexander Dovlatov on 6/17/23.
//

import Foundation
import UIKit

final class CountryDetailViewModel {
    var country: Country
    let flagId: String
    typealias ActionPublisher = (Action) -> Void
    /// The Action Publisher
    var actionPublisher: ActionPublisher?

    /// The State
    var flagState: FlagState = .initial {
        didSet { actionPublisher?(.updateFlagState(flagState)) } // Notify the publisher on the flag state change
    }

    /// The Data Task used to fetch the image
    private weak var dataTask: URLSessionDataTask?

    init(country: Country) {
        self.country = country
        self.flagId = "flag@\(country.id)"
    }

    /// Setup the view model with the view
    func setup(with view: CountryDetailView) {
        view.countryNameView.text = "\(LocalizationKeys.countryDetails_name.localizedValue()): \(country.name)"
        view.countryCapitalView.text = "\(LocalizationKeys.countryDetails_capital.localizedValue()): \(country.capital)"
        view.countryRegionView.text = "\(LocalizationKeys.countryDetails_region.localizedValue()): \(country.region)"
        view.countryCodeView.text = "\(LocalizationKeys.countryDetails_code.localizedValue()): \(country.code)"
        view.countryLanguageView.text = "\(LocalizationKeys.countryDetails_currency.localizedValue()): \(country.language.name)"
        view.countryCurrencyView.text = "\(LocalizationKeys.countryDetails_language.localizedValue()): \(country.currency.name)"

        if let data = APP.svgImageCache.getElement(for: flagId) {
            flagState = .loaded
            actionPublisher?(.updateFlagSVGData(data))
        } else if let url = Bundle.main.url(forResource: "usa.flag", withExtension: "svg"),
                  let data = try? Data(contentsOf: url) {

            actionPublisher?(.updateFlagSVGData(data))
        }
        fetchFlag()
    }

    /// Runs the flag image fetch request
    func fetchFlag() {
        guard case FlagState.initial = flagState else { return }
        dataTask?.cancel()
        flagState = .loading

        let flagId = self.flagId
        let task = APP.apiService.fetchData(endpoint: ResourceEndpoint.custom(country.flagImageURL)) { [weak self] result in
            switch result {
            case .success(let data):
                self?.actionPublisher?(.updateFlagSVGData(data))
                APP.svgImageCache.setElement(data, for: flagId)

                self?.flagState = .loaded
            case .failure(let error):
                self?.flagState = .failure(error)
            }
        }

        self.dataTask = task
        task.resume()
    }
}

extension CountryDetailViewModel {
    /// The Flag Image State
    enum FlagState {
        case initial
        case loading
        case loaded
        case failure(Error)
    }
    /// Actions that are published to the view controller
    enum Action {
        /// Updates the state
        case updateFlagState(FlagState)
        /// Updates the flag image (SVG Data)
        case updateFlagSVGData(Data)
    }
}
