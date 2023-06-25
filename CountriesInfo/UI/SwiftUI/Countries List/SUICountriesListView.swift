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
        Group {
            switch viewModel.state {
            case .initial:
                ColorName.commonBackground.suiColor()
                    .onAppear(perform: viewModel.fetch)
            case .loaded:
                ZStack {
                    NavigationSplitView {
                        SUICountriesListContentView(viewModel: viewModel)
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
                        Button(LocalizationKeys.countriesList_reload.localizedValue(), action: viewModel.fetch)
                    })
            case .loading:
                Text(LocalizationKeys.countriesList_loading)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(ColorName.commonBackground.suiColor())
            }
        }
    }
}

struct SUICountriesListView_Previews: PreviewProvider {
    static var previews: some View {
        SUICountriesListView()
    }
}
