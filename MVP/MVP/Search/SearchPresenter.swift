//
//  SearchViewPresenter.swift
//  MVP
//
//  Created by  Gleb Tarasov on 09/08/2018.
//  Copyright © 2018 Gleb Tarasov. All rights reserved.
//

import Foundation

struct SearchCellViewModel: Equatable {
    let title: String
    let subtitle: String
}

protocol SearchPresenterProtocol {
    func onViewDidLoad()
    func searchTextChanged(_ text: String?)
}

class SearchPresenter: SearchPresenterProtocol {

    weak var viewController: SearchViewControllerProtocol?

    enum State: Equatable {
        case loading
        case empty
        case error(String)
        case rows([SearchCellViewModel])

        static func == (lhs: State, rhs: State) -> Bool {
            switch (lhs, rhs) {
            case (.loading, .loading):
                return true
            case (.empty, .empty):
                return true
            case let (.error(lhs), .error(rhs)):
                return lhs == rhs
            case let (.rows(lhs), .rows(rhs)):
                return lhs == rhs
            default:
                return false
            }
        }
    }

    private let service: SearchServiceProtocol

    var title: String {
        return "Search Places"
    }

    init(service: SearchServiceProtocol) {
        self.service = service
    }

    func onViewDidLoad() {
        viewController?.update(.empty, animated: false)
    }

    func searchTextChanged(_ text: String?) {
        throttler.throttle { [weak self] in
            self?.performSearchTextChanged(text)
        }
    }
    private let throttler = Throttler(maxInterval: 0.5)

    // only for tests
    func fulfillThrottler() {
        throttler.fulfill()
    }

    private func performSearchTextChanged(_ text: String?) {
        guard let text = text, text.count > 1 else {
            viewController?.update(.empty, animated: true)
            return
        }
        viewController?.update(.loading, animated: true)
        service.search(query: text)
            .get(on: DispatchQueue.main) { [weak self] data in
                let rows = data.compactMap { self?.viewModel(for: $0) }
                if rows.count > 0 {
                    self?.viewController?.update(.rows(rows), animated: true)
                } else {
                    self?.viewController?.update(.empty, animated: true)
                }
            }
            .catch(on: DispatchQueue.main) { [weak self] error in
                self?.viewController?.update(.error(error.localizedDescription), animated: true)
        }
    }

    private func viewModel(for place: Place) -> SearchCellViewModel {
        return SearchCellViewModel(title: place.displayName,
                                   subtitle: "\(place.lat), \(place.lon)")
    }
}
