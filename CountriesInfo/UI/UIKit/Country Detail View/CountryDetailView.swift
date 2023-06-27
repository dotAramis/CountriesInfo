//
//  CountryDetailView.swift
//  CountriesInfo
//
//  Created by Alexander Dovlatov on 6/17/23.
//

import Foundation
import UIKit
import SVGView
import SwiftUI

final class CountryDetailView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = ColorName.commonBackground.uiColor()
        setupHierarchy()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Views
    private let mainContainerView: UIScrollView = {
        let view = UIScrollView(frame: UIScreen.main.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let dynamicContainerView: UIStackView = {
        let view = UIStackView(frame: UIScreen.main.bounds)
        view.axis = .vertical
        view.alignment = .center
        view.distribution = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        view.spacing = UIConstants.baseVerticalSpacing
        return view
    }()

    private let verticalContainerView: UIStackView = {
        let view = UIStackView(frame: UIScreen.main.bounds)
        view.axis = .vertical
        view.alignment = .leading
        view.distribution = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        view.spacing = UIConstants.baseVerticalSpacing
        return view
    }()

    let loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        view.hidesWhenStopped = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.color = ColorName.loader.uiColor()
        return view
    }()

    var svgData: Data? {
        didSet {
            flagController?.view.removeFromSuperview()
            guard let data = svgData else { return }
            let controller = UIHostingController(rootView: SVGView(data: data))
            self.flagController = controller
            controller.view.translatesAutoresizingMaskIntoConstraints = false

            flagView.addSubview(controller.view)
            controller.view.backgroundColor = .clear
            NSLayoutConstraint.activate([
                controller.view.topAnchor.constraint(equalTo: flagView.topAnchor),
                controller.view.leadingAnchor.constraint(equalTo: flagView.leadingAnchor),
                controller.view.trailingAnchor.constraint(equalTo: flagView.trailingAnchor),
                controller.view.bottomAnchor.constraint(equalTo: flagView.bottomAnchor)
            ])
        }
    }
    private var flagController: UIHostingController<SVGView>?

    let flagView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh,
                                                     for: NSLayoutConstraint.Axis.vertical)
        return view
    }()

    let countryNameView: UILabel = {
        let label = UILabel()
        label.text = LocalizationKeys.root_title.localizedValue()
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.textColor = ColorName.commonCaptionText.uiColor()
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    let countryCapitalView: UILabel = {
        let label = UILabel()
        label.text = LocalizationKeys.root_title.localizedValue()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = ColorName.commonCaptionText.uiColor()
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    let countryRegionView: UILabel = {
        let label = UILabel()
        label.text = LocalizationKeys.root_title.localizedValue()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = ColorName.commonCaptionText.uiColor()
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    let countryCodeView: UILabel = {
        let label = UILabel()
        label.text = LocalizationKeys.root_title.localizedValue()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = ColorName.commonCaptionText.uiColor()
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    let countryLanguageView: UILabel = {
        let label = UILabel()
        label.text = LocalizationKeys.root_title.localizedValue()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = ColorName.commonCaptionText.uiColor()
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    let countryCurrencyView: UILabel = {
        let label = UILabel()
        label.text = LocalizationKeys.root_title.localizedValue()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = ColorName.commonCaptionText.uiColor()
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    // MARK: Lifecycle
    /// Setup the hierarchy
    private func setupHierarchy() {
        addSubview(mainContainerView)
        mainContainerView.addSubview(dynamicContainerView)

        dynamicContainerView.addArrangedSubview(flagView)

        dynamicContainerView.addArrangedSubview(verticalContainerView)

        verticalContainerView.addArrangedSubview(countryNameView)
        verticalContainerView.addArrangedSubview(countryCapitalView)
        verticalContainerView.addArrangedSubview(countryCodeView)
        verticalContainerView.addArrangedSubview(countryLanguageView)
        verticalContainerView.addArrangedSubview(countryCurrencyView)

        addSubview(loadingView)
    }

    /// Setup constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainContainerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            mainContainerView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            mainContainerView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            mainContainerView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
        ])

        NSLayoutConstraint.activate([
            dynamicContainerView.centerXAnchor.constraint(equalTo: mainContainerView.centerXAnchor),
            dynamicContainerView.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor),
            dynamicContainerView.topAnchor.constraint(equalTo: mainContainerView.topAnchor),
            dynamicContainerView.leadingAnchor.constraint(equalTo: mainContainerView.leadingAnchor),
            dynamicContainerView.trailingAnchor.constraint(equalTo: mainContainerView.trailingAnchor),
            dynamicContainerView.bottomAnchor.constraint(equalTo: mainContainerView.bottomAnchor),
        ])

        let maxWidthConstraint = flagView.heightAnchor.constraint(equalTo: widthAnchor)
        maxWidthConstraint.priority = .defaultHigh
        NSLayoutConstraint.activate([
            flagView.heightAnchor.constraint(equalTo: flagView.widthAnchor, multiplier: 0.7),
            flagView.widthAnchor.constraint(lessThanOrEqualTo: mainContainerView.widthAnchor, multiplier: 0.7),
            flagView.heightAnchor.constraint(lessThanOrEqualTo: mainContainerView.heightAnchor, multiplier: 0.7),
            maxWidthConstraint
        ])

        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: flagView.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: flagView.centerYAnchor),
        ])

    }

    // MARK: UI callbacks
    override func updateConstraints() {
        super.updateConstraints()
        if self.traitCollection.horizontalSizeClass == .compact || UIDevice().userInterfaceIdiom == .pad {
            dynamicContainerView.axis = .vertical
        } else {
            dynamicContainerView.axis = .horizontal
        }
    }
}
