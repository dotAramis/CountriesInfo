//
//  CountryInfoCell.swift
//  CountriesInfo
//
//  Created by Alexander Dovlatov on 6/17/23.
//

import Foundation
import UIKit

/// The cell representing a country in the list view
final class CountryInfoCell: UITableViewCell {
    /// The view model
    let viewModel: CountryInfoCellModel = CountryInfoCellModel()

    // MARK: - Views and guides
    /// The title (name and region)
    private let titleView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.textColor = ColorName.commonCaptionText.uiColor()
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    /// The title (code)
    private let codeView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.textColor = ColorName.commonCaptionText.uiColor()
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    /// The title (capital)
    private let capitalView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = ColorName.commonCaptionText.uiColor()
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    // MARK: Lifecycle
    /// The main init function
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupHierarchy()
        setupConstraints()
        setupActionHandlers()
    }

    /// The storyboard init
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Setup the hierarchy
    private func setupHierarchy() {
        contentView.addSubview(titleView)
        contentView.addSubview(codeView)
        contentView.addSubview(capitalView)
    }
    /// Setup the constraints
    private func setupConstraints() {
        // titleView
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: UIConstants.baseVerticalSpacing),
            titleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: UIConstants.baseHorizontalSpacing),
            titleView.trailingAnchor.constraint(lessThanOrEqualTo: codeView.leadingAnchor, constant: -UIConstants.baseHorizontalSpacing)
        ])

        // capitalView
        NSLayoutConstraint.activate([
            capitalView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: UIConstants.baseVerticalSpacing),
            capitalView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: UIConstants.baseHorizontalSpacing),
            capitalView.trailingAnchor.constraint(lessThanOrEqualTo: codeView.leadingAnchor, constant: -UIConstants.baseHorizontalSpacing),
            capitalView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -UIConstants.baseVerticalSpacing),
        ])

        // codeView
        NSLayoutConstraint.activate([
            codeView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: UIConstants.baseVerticalSpacing),
            codeView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -UIConstants.baseHorizontalSpacing),
            codeView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -UIConstants.baseVerticalSpacing),
        ])
        codeView.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh + 1, for: .horizontal)
        codeView.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
    }

    // MARK: - Interaction
    /// Setup the view model to view action handlers
    private func setupActionHandlers() {
        viewModel.actionPublisher = { [weak self] action in
            switch action {
            case .updateText(name: let name,
                             region: let region,
                             code: let code,
                             capital: let capital):
                self?.titleView.text = "\(name), \(region)"
                self?.codeView.text = code
                self?.capitalView.text = capital
            }
        }
    }
}
