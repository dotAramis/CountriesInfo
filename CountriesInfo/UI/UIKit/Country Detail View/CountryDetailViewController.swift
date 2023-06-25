//
//  CountryDetailViewController.swift
//  CountriesInfo
//
//  Created by Alexander Dovlatov on 6/17/23.
//

import Foundation
import UIKit

final class CountryDetailViewController: UIViewController {
    let viewModel: CountryDetailViewModel

    init(viewModel: CountryDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var rootView: CountryDetailView = {
        let view = CountryDetailView(frame: UIScreen.main.bounds)
        return view
    }()
    
    override func loadView() {
        self.view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // The View Model callbacks handler
        viewModel.actionPublisher = { [weak self] action in
            DispatchQueue.main.async {
                switch action {
                case .updateFlagSVGData(let data):
                    self?.rootView.flagView.load(data, mimeType: "image/svg+xml", characterEncodingName: "utf8", baseURL: Bundle.main.bundleURL)
                    break
                case .updateFlagState(let state):
                    switch state {
                    case .loaded: self?.rootView.loadingView.stopAnimating()
                    case .loading: self?.rootView.loadingView.startAnimating()
                    case .failure: self?.rootView.loadingView.stopAnimating()
                    case .initial: self?.rootView.loadingView.stopAnimating()
                    }
                }
            }
        }
        viewModel.setup(with: rootView)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if case .initial = self.viewModel.flagState {
            viewModel.fetchFlag()
        }
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if previousTraitCollection?.horizontalSizeClass != view.traitCollection.horizontalSizeClass {
            view.setNeedsUpdateConstraints()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
}
