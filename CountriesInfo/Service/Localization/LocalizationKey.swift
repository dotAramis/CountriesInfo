//
//  LocalizationKey.swift
//  CountriesInfo
//
//  Created by Alexander Dovlatov on 6/17/23.
//

import Foundation
import SwiftUI

/// The Licalization Key
protocol LocalizationKey {
    var rawKey: String { get }
}

extension LocalizationKey where Self: RawRepresentable, Self.RawValue == String {
    var rawKey: String { return rawValue }
}

extension LocalizationKey {
    func localizedValue() -> String {
        return APP.localizationService.localizedString(for: self)
    }
}

/// The list of all localization keys
enum LocalizationKeys: String, LocalizationKey, CaseIterable {
    case root_title = "root-title"
    case root_loading = "root-loading"
    case root_error = "root-error"
    case root_back = "root-back"
    case root_selectFlow_button = "root-selectFlowButton"
    case root_selectFlow_message = "root-selectFlowMessage"
    case root_author_button = "root-authorButton"

    case countriesList_reload = "countriesList-reload"
    case countriesList_close = "countriesList-close"
    case countriesList_loading = "countriesList-loading"
    case countriesList_selectCountry = "countriesList-selectCountry"

    case countryDetails_name = "countryDetails-name"
    case countryDetails_capital = "countryDetails-capital"
    case countryDetails_region = "countryDetails-region"
    case countryDetails_code = "countryDetails-code"
    case countryDetails_currency = "countryDetails-currency"
    case countryDetails_language = "countryDetails-language"
    case countryDetails_info = "countryDetails-info"
}

extension Text {
    /// The convenience initializer
    init(_ localizationKey: LocalizationKey) {
        self.init(localizationKey.localizedValue())
    }
}
