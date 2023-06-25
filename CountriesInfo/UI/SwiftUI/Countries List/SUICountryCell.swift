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
                .monospaced()
                .foregroundColor(ColorName.commonCaptionText.suiColor())
        }
    }
}

struct SUICountryCell_Previews: PreviewProvider {
    static var previews: some View {
        let country = Country(name: "Name", capital: "Capital", code: "CC", flagImageURL: Bundle.main.bundleURL, language: Language(code: "LC", name: "LN"), currency: Currency(code: "CC", name: "CN", symbol: "CS"), region: "Region")

        return Group {
            SUICountryCell(country: country)
                .background(ColorName.commonBackground.suiColor())
                .environment(\.colorScheme, .light)
                .previewDisplayName("Light Mode")
                .previewLayout(PreviewLayout.sizeThatFits)

            SUICountryCell(country: country)
                .background(ColorName.commonBackground.suiColor())
                .environment(\.colorScheme, .dark)
                .previewDisplayName("Dark Mode")
                .previewLayout(PreviewLayout.sizeThatFits)
        }
    }
}
