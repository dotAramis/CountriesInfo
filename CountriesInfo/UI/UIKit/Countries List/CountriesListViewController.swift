//
//  CountriesListViewController.swift
//  CountriesInfo
//
//  Created by Alexander Dovlatov on 6/17/23.
//

import Foundation
import UIKit

/// The Countries List View Controller
final class CountriesListViewController: UIViewController {
    /// The cell identifier used to dequeue the cell
    static let countryCellIdentifier: String = "CountryCell"
    /// The View Model
    private let viewModel: CountriesListViewModel = CountriesListViewModel()
    /// The Table View DataSource
    private lazy var dataSource = makeDataSource()
    /// Debounce timer
    fileprivate weak var timer: Timer?
    /// The Search Controller used to filter the countries
    let searchController = UISearchController(searchResultsController: nil)

    /// The Table View Section
    enum Section {
        case countries
    }

    // MARK: - Views
    /// The main Table View
    let tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ColorName.commonBackground.uiColor()
        view.rowHeight = UITableView.automaticDimension
        view.estimatedRowHeight = 60
        return view
    }()

    /// The error Label
    let errorView: UILabel = {
        let label = UILabel()
        label.text = LocalizationKeys.root_error.localizedValue()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        label.textColor = ColorName.commonText.uiColor()
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        label.isHidden = true
        return label
    }()

    /// The loading view
    private let loadingView: UIView = {
        let label = UILabel()
        label.text = LocalizationKeys.root_loading.localizedValue()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        label.textColor = ColorName.commonText.uiColor()
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = LocalizationKeys.root_title.localizedValue()
        view.backgroundColor = ColorName.commonBackground.uiColor()

        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.close,
                            target: self,
                            action: #selector(close)),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.refresh,
                                                            target: self,
                                                            action: #selector(refetch)),
        ]
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController

        setupHierarchy()
        setupConstraints()
        setupActionHandlers()

        tableView.register(CountryInfoCell.self, forCellReuseIdentifier: Self.countryCellIdentifier)
        tableView.dataSource = makeDataSource()
        tableView.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if case .initial = viewModel.state {
            viewModel.fetch()
        }
    }

    // MARK: - Setup
    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            errorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

    private func setupHierarchy() {
        view.addSubview(tableView)
        view.addSubview(loadingView)
        view.addSubview(errorView)
    }

    // MARK: - Interaction
    /// Setup the view model to view action handlers
    private func setupActionHandlers() {
        viewModel.actionPublisher = { [weak self] action in
            switch action {
            case .updateCountries(let snapshot):
                DispatchQueue.main.async {
                    self?.dataSource.apply(snapshot,
                                           animatingDifferences: true,
                                           completion: nil)
                }
            case .updateState(let state):
                guard let self = self else { return }
                DispatchQueue.main.async {
                    switch state {
                    case .initial:
                        self.tableView.setIsHidden(true)
                        self.searchController.resignFirstResponder()
                        self.errorView.setIsHidden(true)
                        self.loadingView.setIsHidden(true)
                    case .loading:
                        self.tableView.setIsHidden(true)
                        self.searchController.resignFirstResponder()
                        self.errorView.setIsHidden(true)
                        self.loadingView.setIsHidden(false)
                    case .loaded:
                        self.tableView.setIsHidden(false)
                        self.searchController.resignFirstResponder()
                        self.errorView.setIsHidden(true)
                        self.loadingView.setIsHidden(true)
                    case .failure:
                        self.tableView.setIsHidden(true)
                        self.searchController.resignFirstResponder()
                        self.errorView.setIsHidden(false)
                        self.loadingView.setIsHidden(true)
                    }
                }
            }
        }
    }

    /// Re-fetch the data
    @objc private func refetch() {
        viewModel.fetch()
    }

    /// Close the screen
    @objc private func close() {
        APP.navigationState.selectedFlow = nil
    }

    /// Makes the data source
    /// - Returns: The diffable datasource rady to be used with the TableView
    func makeDataSource() -> UITableViewDiffableDataSource<CountriesListViewController.Section, Country> {
        return UITableViewDiffableDataSource(
            tableView: tableView,
            cellProvider: { [weak self]  tableView, indexPath, contact in
                let cell = tableView.dequeueReusableCell(withIdentifier: Self.countryCellIdentifier, for: indexPath)
                cell.selectionStyle = .none
                if let cell = cell as? CountryInfoCell, let viewModel = self?.viewModel {
                    cell.viewModel.setup(with: viewModel.filteredCountries[indexPath.row])
                    cell.backgroundColor = .clear
                }
                return cell
            }
        )
    }
}

extension CountriesListViewController: UITableViewDelegate {
    /// Shows the detail view controller
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let country = viewModel.filteredCountries[indexPath.row]
        let viewModel = CountryDetailViewModel(country: country)
        let detailsViewController = CountryDetailViewController(viewModel: viewModel)
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
}

extension CountriesListViewController: UISearchResultsUpdating {
    /// The Search controller `searchResultsUpdater` delegate method (`UISearchResultsUpdating`)
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, searchText.count > 0 else {
            viewModel.searchText = nil
            return
        }

        timer?.invalidate()

        let timer = Timer(timeInterval: 0.5, repeats: false) { [weak self] timer in
            self?.viewModel.searchText = searchText
        }
        self.timer = timer
        RunLoop.main.add(timer, forMode: RunLoop.Mode.default)
    }
}
