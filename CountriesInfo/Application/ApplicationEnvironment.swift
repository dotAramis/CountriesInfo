//
//  ApplicationEnvironment.swift
//  CountriesInfo
//
//  Created by Alexander Dovlatov on 6/17/23.
//

import Foundation

/// The Application work environment
enum ApplicationEnvironment: String {
    case production
    case mock

    static func get() -> ApplicationEnvironment {
        guard let key = ProcessInfo.processInfo.environment["env"] else { return .production }
        return ApplicationEnvironment(rawValue: key) ?? ApplicationEnvironment.production
    }

    var name: String { return rawValue }
}
