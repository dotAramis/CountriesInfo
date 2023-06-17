//
//  CountryInfoCellModel.swift
//  CountriesInfo
//
//  Created by Alexander Dovlatov on 6/17/23.
//

import Foundation

/// The CountryInfoCell View Model
final class CountryInfoCellModel {
    typealias ActionPublisher = (Action) -> Void
    /// The Action Publisher
    var actionPublisher: ActionPublisher?

    /// Setup the view model to render the Country
    /// - Parameter country: The country to render with
    func setup(with country: Country) {
        actionPublisher?(Action.updateText(name: country.name,
                                           region: country.region,
                                           code: country.code,
                                           capital: country.capital))
    }
}

extension CountryInfoCellModel {
    /// Actions that are published to the cell
    enum Action {
        /// Updates the labels on the cell
        case updateText(name: String, region: String, code: String, capital: String)
    }
}
