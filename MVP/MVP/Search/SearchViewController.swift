//
//  SearchViewController.swift
//  MVP
//
//  Created by  Gleb Tarasov on 09/08/2018.
//  Copyright © 2018 Gleb Tarasov. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell, Cell {
    typealias Data = SearchCellViewModel

    func update(data: SearchCellViewModel) {
        textLabel?.text = data.title
        detailTextLabel?.text = data.subtitle
    }
}

protocol SearchViewControllerProtocol: class {
    func update(_ state: SearchPresenter.State, animated: Bool)
}

class SearchViewController: UIViewController,
                            SearchViewControllerProtocol,
                            UISearchBarDelegate {

    var presenter: SearchPresenterProtocol!

    @IBOutlet private var searchBar: UISearchBar!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var errorLabel: UILabel!
    @IBOutlet private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        assert(presenter != nil)
        presenter.onViewDidLoad()
    }

    func update(_ state: SearchPresenter.State, animated: Bool) {
        let action = {
            switch state {
            case .empty:
                self.activityIndicator.stopAnimating()
                self.errorLabel.alpha = 0
                self.tableView.alpha = 0
            case let .error(error):
                self.activityIndicator.stopAnimating()
                self.errorLabel.alpha = 1
                self.errorLabel.text = error
                self.tableView.alpha = 0
            case .loading:
                self.activityIndicator.startAnimating()
                self.errorLabel.alpha = 0
                self.tableView.alpha = 0
            case let .rows(rows):
                self.activityIndicator.stopAnimating()
                self.errorLabel.alpha = 0
                self.tableView.alpha = 1
                self.displayRows(rows)
            }
        }

        if animated {
            UIView.animate(withDuration: 0.3, animations: action)
        } else {
            action()
        }
    }

    private func displayRows(_ rows: [SearchCellViewModel]) {
        self.dataSource = TableDataSource(tableView: tableView, data: rows)
    }
    private var dataSource: TableDataSource<SearchCell, SearchCellViewModel>?

    @IBAction private func resign() {
        searchBar.resignFirstResponder()
    }

    // MARK: - UISearchBarDelegate

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.searchTextChanged(searchText)
    }
}
