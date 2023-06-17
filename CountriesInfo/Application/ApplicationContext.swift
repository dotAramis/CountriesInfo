//
//  ApplicationContext.swift
//  CountriesInfo
//
//  Created by Alexander Dovlatov on 6/16/23.
//

import Foundation
import Combine

/// The convenience handler for the `ApplicationContext.shared`
let APP = ApplicationContext.shared

/// The main Application Context object.
/// Ownes the Application Services
final class ApplicationContext {
    static let shared = ApplicationContext.load(environment: ApplicationEnvironment.get())
    private var bag: Set<AnyCancellable> = Set()

    let configurationService: ConfigurationService
    let apiService: APIService
    let imageCache: any ImageCacheService
    let localizationService: LocalizationService
    let dataControllerService: DataControllerService
    let navigationState: NavigationState

    init(configurationService: ConfigurationService,
         apiService: APIService,
         imageCache: any ImageCacheService,
         countriesDataController: CountriesDataController) {
        self.configurationService = configurationService
        self.apiService = apiService
        self.imageCache = imageCache
        self.dataControllerService = DataControllerService()
        self.localizationService = LocalizationService()
        self.navigationState = NavigationState()
        
        self.setupSubscriptions()
    }

    /// links the services
    private func setupSubscriptions() {
        configurationService
            .$configuration
            .map(\.API)
            .assign(to: \.configuration, on: self.apiService)
            .store(in: &bag)
    }
}

extension ApplicationContext {
    /// Loads the context based on the configuration
    static func load(environment: ApplicationEnvironment) -> ApplicationContext {
        do {
            print("Starting the app with \(environment) environment")
            let configurationService = try ConfigurationService(loader: MockConfigurationServiceLoader(environment: environment),
                                                                environment: environment)

            return ApplicationContext(configurationService: configurationService,
                                      apiService: try self.APIService(for: environment,
                                                                      configurationService: configurationService),
                                      imageCache: InMemoryImageCacheService(),
                                      countriesDataController: CountriesDataController())
        } catch {
            // We cannot proceed without a configuration. Falling down in a not very graceful manner.
            fatalError("Error loading Application context: \(error)")
        }
    }

    private static func APIService(for environment: ApplicationEnvironment,
                                   configurationService: ConfigurationService) throws -> APIService {
        
        switch environment {
        case .production: return RemoteAPIService(configuration: configurationService.configuration.API)
        case .mock: return MockAPIService()
        }
    }
}
