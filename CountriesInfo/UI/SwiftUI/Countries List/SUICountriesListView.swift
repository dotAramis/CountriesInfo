//
//  SUICountriesListView.swift
//  CountriesInfo
//
//  Created by Alexander Dovlatov on 6/17/23.
//

import Foundation
import SwiftUI

/// The Countries List View
struct SUICountriesListView: View {
    /// The View Model
    @StateObject private var viewModel: SUICountriesListViewModel = SUICountriesListViewModel()

    var body: some View {
        switch viewModel.state {
        case .initial:
            Color.clear
                .onAppear {
                    viewModel.fetch()
                }
        case .loaded:
            ZStack {
                NavigationSplitView {
                    List(viewModel.filteredCountries, selection: $viewModel.selection) { country in
                        NavigationLink {
                            SUICountryDetailView(country: country)
                        } label: {
                            SUICountryCell(country: country)
                        }
                    }
                    .background(ColorName.commonBackground.suiColor())
                    .toolbar(content: {
                        Button(LocalizationKeys.countriesList_reload.localizedValue(), action: viewModel.fetch)
                        Button(LocalizationKeys.countriesList_close.localizedValue()) { viewModel.close() }
                    })
                    .searchable(text: $viewModel.searchText)
                } detail: {
                    if let selection = viewModel.selection {
                        SUICountryDetailView(country: selection)
                    } else {
                        Text(LocalizationKeys.countriesList_selectCountry)
                    }
                }
            }
        case .failure(let error):
            Text("Error: \(error.localizedDescription)")
                .toolbar(content: {
                    Button(LocalizationKeys.countriesList_reload.localizedValue()) { viewModel.fetch() }
                })
        case .loading:
            Text(LocalizationKeys.countriesList_loading)
        }
    }
}
