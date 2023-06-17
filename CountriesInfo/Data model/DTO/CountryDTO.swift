//
//  CountryDTO.swift
//  CountriesInfo
//
//  Created by Alexander Dovlatov on 6/16/23.
//

import Foundation

/// The data transfer model object
struct CountryDTO: Decodable {
    let name: String
    let capital: String
    let code: String
    let flag: String
    let language: LanguageDTO
    let currency: CurrencyDTO
    let region: String
}
