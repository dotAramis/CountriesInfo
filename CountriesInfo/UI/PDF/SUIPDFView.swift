//
//  SUIPDFView.swift
//  CountriesInfo
//
//  Created by Alexander Dovlatov on 6/18/23.
//

import Foundation
import SwiftUI
import UIKit
import PDFKit

/// The PDF Viewer wrapper for Swift UI
struct SUIPDFView: UIViewRepresentable {
    typealias UIViewType = PDFView
    let url: URL

    func makeUIView(context: Context) -> UIViewType {
        let pdfView = PDFView()
        pdfView.document = PDFDocument(url: self.url)
        pdfView.pageShadowsEnabled = false
        pdfView.autoScales = true
        return pdfView
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        // Nothing to do here
    }
}
