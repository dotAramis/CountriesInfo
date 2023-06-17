//
//  Language.swift
//  CountriesInfo
//
//  Created by Alexander Dovlatov on 6/16/23.
//

import Foundation

/// The real model object
struct Language: Hashable {
    let code: String?
    let name: String

    init(code: String?,
         name: String) {
        self.code = code
        self.name = name
    }

    init(dto: LanguageDTO) {
        self.code = dto.code
        self.name = dto.name
    }
}
