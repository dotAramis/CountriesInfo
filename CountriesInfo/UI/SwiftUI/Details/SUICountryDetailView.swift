//
//  SUICountryDetailView.swift
//  CountriesInfo
//
//  Created by Alexander Dovlatov on 6/17/23.
//

import SwiftUI
import SVGView

/// The Country Details View
struct SUICountryDetailView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @StateObject private var viewModel: SUICountryDetailViewModel

    init(country: Country) {
        self._viewModel = StateObject(wrappedValue: SUICountryDetailViewModel(country: country))
    }

    /// Builds the main view
    @ViewBuilder func mainViews() -> some View {
        Spacer().frame(width: UIConstants.baseHorizontalSpacing, height: UIConstants.baseVerticalSpacing)
        List {
            Section {
                Group {
                    if let imageData = viewModel.flagData ?? viewModel.flagPlaceholderData {
                        SVGView(data: imageData)
                    } else {
                        Image(ImageName.logo)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                }
                .listRowBackground(Color.clear)
                .frame(height: 300)
                .onAppear { viewModel.loadFlag() }
            } header: {
                Text(LocalizationKeys.countryDetails_flag)
            }

            Section {
                Group {
                    Text("\(LocalizationKeys.countryDetails_name.localizedValue()): \(viewModel.country.name)")
                    Text("\(LocalizationKeys.countryDetails_capital.localizedValue()): \(viewModel.country.capital)")
                    Text("\(LocalizationKeys.countryDetails_region.localizedValue()): \(viewModel.country.region)")
                    Text("\(LocalizationKeys.countryDetails_code.localizedValue()): \(viewModel.country.code)")
                    Text("\(LocalizationKeys.countryDetails_currency.localizedValue()): \(viewModel.country.currency.name)")
                    Text("\(LocalizationKeys.countryDetails_language.localizedValue()): \(viewModel.country.language.name)")
                }
                .listRowBackground(Color.clear)
            } header: {
                Text(LocalizationKeys.countryDetails_info)
            }
            .background(Color.clear)
            .scrollContentBackground(.hidden)
        }
        .scrollContentBackground(Visibility.hidden)
        .listStyle(.grouped)
    }

    var body: some View {
        Group {
            if horizontalSizeClass == .compact || UIDevice().userInterfaceIdiom == .pad {
                VStack {
                    mainViews()
                }
            } else {
                HStack {
                    mainViews()
                }
            }
        }
        .background(ColorName.commonBackground.suiColor())
    }
}

struct SUICountryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let country = Country(name: "Name", capital: "Capital", code: "CC", flagImageURL: Bundle.main.bundleURL, language: Language(code: "LC", name: "LN"), currency: Currency(code: "CC", name: "CN", symbol: "CS"), region: "Region")
        return SUICountryDetailView(country: country)
    }
}
