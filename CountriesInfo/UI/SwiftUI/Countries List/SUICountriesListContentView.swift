//
//  SUICountriesListContentView.swift
//  CountriesInfo
//
//  Created by Alexander Dovlatov on 6/24/23.
//

import SwiftUI

struct SUICountriesListContentView: View {
    @ObservedObject private var viewModel: SUICountriesListViewModel
    init(viewModel: SUICountriesListViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        Group {
            if !viewModel.filteredCountries.isEmpty {
                List(viewModel.filteredCountries, selection: $viewModel.selection) { country in
                    NavigationLink {
                        SUICountryDetailView(country: country)
                    } label: {
                        SUICountryCell(country: country)
                    }.listRowBackground(Color.clear)
                }
                .scrollContentBackground(Visibility.hidden)
                .listStyle(.grouped)
            } else {
                VStack {
                    Text(LocalizationKeys.countriesList_notFound)
                        .font(.caption)
                        .foregroundColor(ColorName.commonCaptionText.suiColor())
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
        .toolbar(content: {
            Button(LocalizationKeys.countriesList_reload.localizedValue(), action: viewModel.fetch)
            Button(LocalizationKeys.countriesList_close.localizedValue(), action: viewModel.close)
        })
        .background(ColorName.commonBackground.suiColor())
        .searchable(text: $viewModel.searchText)
    }
}

struct SUICountriesListContentView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = SUICountriesListViewModel()

        return NavigationStack {
            SUICountriesListContentView(viewModel: viewModel)
        }.onAppear {
            viewModel.fetch()
        }

    }
}
