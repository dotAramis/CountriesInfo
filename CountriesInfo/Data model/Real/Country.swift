//
//  Country.swift
//  CountriesInfo
//
//  Created by Alexander Dovlatov on 6/16/23.
//

import Foundation

/// The real model object
struct Country: Hashable, Identifiable {
    var id: String { return "\(name)#\(code)" }

    let name: String
    let capital: String
    let code: String
    let flagImageURL: URL
    let language: Language
    let currency: Currency
    let region: String
    
    init(name: String,
         capital: String,
         code: String,
         flagImageURL: URL,
         language: Language,
         currency: Currency,
         region: String) {
        self.name = name
        self.capital = capital
        self.code = code
        self.flagImageURL = flagImageURL
        self.language = language
        self.currency = currency
        self.region = region
    }

    init(dto: CountryDTO) throws {
        self.name = dto.name
        self.capital = dto.capital
        self.code = dto.code
        guard let flagImageURL = URL(string: dto.flag) else { throw URLError(.badURL) }
        self.flagImageURL = flagImageURL
        self.language = Language(dto: dto.language)
        self.currency = Currency(dto: dto.currency)
        self.region = dto.region
    }
}
