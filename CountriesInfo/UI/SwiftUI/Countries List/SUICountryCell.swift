//
//  SUICountryCell.swift
//  CountriesInfo
//
//  Created by Alexander Dovlatov on 6/17/23.
//

import SwiftUI

/// The Country cell for the list
struct SUICountryCell: View {
    let country: Country
    var body: some View {
        HStack() {
            VStack(alignment: .leading, spacing: 0) {
                Text([country.name, country.region].joined(separator: ", "))
                    .font(.title)
                    .foregroundColor(ColorName.commonCaptionText.suiColor())
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                Spacer()
                Text(country.capital)
                    .font(.body)
                    .foregroundColor(ColorName.commonCaptionText.suiColor())
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            Spacer()
            Text(country.code)
                .font(.largeTitle)
                .foregroundColor(ColorName.commonCaptionText.suiColor())
        }
    }
}
