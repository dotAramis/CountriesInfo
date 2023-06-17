//
//  CountryDetailViewModel.swift
//  CountriesInfo
//
//  Created by Alexander Dovlatov on 6/17/23.
//

import Foundation
import UIKit
import SVGKit

final class CountryDetailViewModel {
    var country: Country
    let flagId: String
    typealias ActionPublisher = (Action) -> Void
    /// The Action Publisher
    var actionPublisher: ActionPublisher?

    var flagImage: UIImage? {
        didSet {
            if let image = flagImage {
                actionPublisher?(.updateFlag(image))
            } else {
                actionPublisher?(.updateFlag(ImageName.logo.uiImage()))
            }
        }
    }
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

        if let image = APP.imageCache.getElement(for: flagId) {
            flagState = .loaded
            actionPublisher?(.updateFlag(image))
        } else {
            actionPublisher?(.updateFlag(nil))
            fetchFlag()
        }
    }

    /// Runs the flag image fetch request
    func fetchFlag() {
        dataTask?.cancel()
        flagState = .loading

        let flagId = self.flagId
        let task = APP.apiService.fetchData(endpoint: ResourceEndpoint.custom(country.flagImageURL)) { [weak self] result in
            switch result {
            case .success(let data):
                guard let svgImage = SVGKImage(data: data) else {
                    self?.flagState = .failure(URLError(.badServerResponse))
                    return
                }

                if svgImage.hasSize() {
                    svgImage.size = CGSize(width: 300, height: 200)
                }

                let uiImage = svgImage.uiImage

                self?.flagImage = uiImage
                self?.flagState = .loaded
                if let uiImage = uiImage {
                    APP.imageCache.setElement(uiImage, for: flagId)
                }
            case .failure(let error):
                self?.flagImage = nil
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
        /// Updates the flag image
        case updateFlag(UIImage?)
    }
}
