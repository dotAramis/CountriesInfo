//
//  CurrencyDTO.swift
//  CountriesInfo
//
//  Created by Alexander Dovlatov on 6/16/23.
//

import Foundation

/// The data transfer model object
struct CurrencyDTO: Decodable {
    let code: String
    let name: String
    let symbol: String?
}
