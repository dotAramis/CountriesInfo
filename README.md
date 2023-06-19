# CountriesInfo

This is a take home project written for the interview.

## Architecture
1. The `ApplicationContext` is the core object of the Application. It owns the services.

### Services
1. `ConfigurationService`: stores and updates the app configuration. This app only uses `MockConfigurationServiceLoader` since there is no real configuration.
1.1. `APIConfiguration`: the Application configuration model.
1.2. `ConfigurationServiceLoader`: used for loading the configuration as a dependency injection.
2. `APIService`: the protocol for fetching data (including JSON).
2.1. `RemoteAPIService`: the "production" API service.
2.2. `MockAPIService`: used for testing and to avoid real requests.
2.3. `ResourceEndpoint`: all pre-bundled endpoints live here. The `APIService` resolves the URL with `resolveEndpoint(_ : ResourceEndpoint, configuration: APIConfiguration) -> URL` method.
3. `LocalizationService`: designed to return localized strings. For now only works at current `Locale`.
3.1. `LocalizationKey`: the storage of all localization strings, testable (see `LocalizationsTests.swift`).
4. `CacheService`: the generic cache protocol.
4.1. `ImageCacheService`: the generic image cache protocol.
4.2. `InMemoryImageCacheService`: the basic image storage. Used in the UI Kit portion of the app.
5. `DataControllerService`: the data controller service. Currently not used but can be integrated into existing MVVM.
5.1. `CountriesDataController`: the `Country` data controller.

### UI
The UI was build (duplicated) both with `UIKit` and `Swift UI`. 
The `UIKit` piece was build "the old way" without using Combine.
The `SwiftUI` piece uses the power of Combine.

The root view is the initial view of the app. Built on `Swift UI`.
Has options to navigate to the `Swift UI` portion and `UI Kit` portions of the app.
Also, the `Author` button will let you learn more about the author.

## Dependencies
The app uses `SVGKit` so please make sure to resolve SPM dependencies
(File -> Packages -> Reset Package Caches) often reselves possible issues