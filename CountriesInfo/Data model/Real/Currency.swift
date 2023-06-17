//
//  Currency.swift
//  CountriesInfo
//
//  Created by Alexander Dovlatov on 6/16/23.
//

import Foundation

/// The real model object
struct Currency: Hashable {
    let code: String
    let name: String
    let symbol: String?

    init(code: String,
         name: String,
         symbol: String?) {
        self.code = code
        self.name = name
        self.symbol = symbol
    }

    init(dto: CurrencyDTO) {
        self.code = dto.code
        self.name = dto.name
        self.symbol = dto.symbol
    }
}
