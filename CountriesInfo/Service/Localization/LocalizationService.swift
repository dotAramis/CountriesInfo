//
//  LocalizationService.swift
//  CountriesInfo
//
//  Created by Alexander Dovlatov on 6/17/23.
//

import Foundation

/// The Localization Service
/// Also can be responsible for loading the translations from the API
final class LocalizationService {
    func localizedString(for key: any LocalizationKey) -> String {
        return NSLocalizedString(key.rawKey, comment: key.rawKey)
    }
}
