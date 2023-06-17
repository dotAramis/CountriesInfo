//
//  SUICountryDetailView.swift
//  CountriesInfo
//
//  Created by Alexander Dovlatov on 6/17/23.
//

import SwiftUI

/// The Country Details View
struct SUICountryDetailView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @StateObject private var viewModel: SUICountryDetailViewModel

    init(country: Country) {
        self._viewModel = StateObject(wrappedValue: SUICountryDetailViewModel(country: country))

    }

    /// Builds the main view
    @ViewBuilder func mainViews() -> some View {
        if let image = viewModel.image {
            image
                .resizable()
                .aspectRatio(1.0 / 0.7, contentMode: .fit)
                .frame(maxWidth: 300, maxHeight: 300)
        } else {
            Image(ImageName.logo)
                .resizable()
                .aspectRatio(1.0, contentMode: .fit)
                .frame(maxWidth: 300, maxHeight: 300)
                .onAppear {
                    if case .initial = viewModel.flagState {
                        viewModel.loadFlag()
                    }
                }
        }
        Spacer().frame(width: UIConstants.baseHorizontalSpacing, height: UIConstants.baseVerticalSpacing)
        List {
            Section {

                Text("\(LocalizationKeys.countryDetails_name.localizedValue()): \(viewModel.country.name)")
                    .listRowBackground(Color.clear)
                Text("\(LocalizationKeys.countryDetails_capital.localizedValue()): \(viewModel.country.capital)")
                    .listRowBackground(Color.clear)
                Text("\(LocalizationKeys.countryDetails_region.localizedValue()): \(viewModel.country.region)")
                    .listRowBackground(Color.clear)
                Text("\(LocalizationKeys.countryDetails_code.localizedValue()): \(viewModel.country.code)")
                    .listRowBackground(Color.clear)
                Text("\(LocalizationKeys.countryDetails_currency.localizedValue()): \(viewModel.country.currency.name)")
                    .listRowBackground(Color.clear)
                Text("\(LocalizationKeys.countryDetails_language.localizedValue()): \(viewModel.country.language.name)")
                    .listRowBackground(Color.clear)
            } header: {
                Text(LocalizationKeys.countryDetails_info)
            }
            .background(Color.clear)
            .scrollContentBackground(.hidden)
        }

        .listStyle(.grouped)
        .scrollContentBackground(.hidden)
    }

    var body: some View {
        if horizontalSizeClass == .compact || UIDevice().userInterfaceIdiom == .pad {
            VStack {
                mainViews()
            }.navigationBarTitle(viewModel.country.name)
        } else {
            HStack {
                mainViews()
            }.navigationBarTitle(viewModel.country.name)
        }
    }
}
