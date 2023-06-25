//
//  SUISVGView.swift
//  CountriesInfo
//
//  Created by Alexander Dovlatov on 6/24/23.
//

import Foundation

import SwiftUI
import WebKit

struct SUISVGView: UIViewRepresentable {
    let data: Data
    func makeUIView(context: Context) -> WKWebView {
        let view = WKWebView()
        view.isOpaque = false
        return view
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        webView.load(data, mimeType: "image/svg+xml", characterEncodingName: "utf8", baseURL: Bundle.main.bundleURL)
    }
}

struct SUISVGView_Previews: PreviewProvider {
    static var previews: some View {
        let data = try! Data(contentsOf: Bundle.main.url(forResource: "usa.flag", withExtension: "svg")!)
        return SUISVGView(data: data)
    }
}
