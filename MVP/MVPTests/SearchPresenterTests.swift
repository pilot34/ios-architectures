//
//  SearchPresenterTests.swift
//  MVPTests
//
//  Created by  Gleb Tarasov on 19/09/2018.
//  Copyright © 2018 Gleb Tarasov. All rights reserved.
//

import Foundation
import XCTest
import PromiseKit
@testable import MVP

class SearchPresenterTests: XCTestCase {
    func testError() {
        let service = MockSearchService()
        let presenter = SearchPresenter(service: service)
        let viewController = MockSearchViewController()
        presenter.viewController = viewController
        XCTAssertEqual(viewController.changes, 0)

        presenter.onViewDidLoad()
        XCTAssertEqual(viewController.changes, 1)
        XCTAssertEqual(viewController.state!, .empty)

        presenter.searchTextChanged("test")
        presenter.fulfillThrottler()
        XCTAssertEqual(viewController.changes, 2)
        XCTAssertEqual(viewController.state!, .loading)
        XCTAssertEqual(service.lastQuery, "test")

        service.reject()
        let predicate = NSPredicate(format: "changes > 2")
        let e = expectation(for: predicate, evaluatedWith: viewController, handler: nil)
        wait(for: [e], timeout: 1)
        XCTAssertEqual(viewController.changes, 3)
        XCTAssertEqual(viewController.state!, .error("TestError"))
    }

    func testSearch() {
        let service = MockSearchService()
        let presenter = SearchPresenter(service: service)
        let viewController = MockSearchViewController()
        presenter.viewController = viewController
        XCTAssertEqual(viewController.changes, 0)

        presenter.onViewDidLoad()
        XCTAssertEqual(viewController.changes, 1)
        XCTAssertEqual(viewController.state!, .empty)

        presenter.searchTextChanged("test")
        presenter.fulfillThrottler()
        XCTAssertEqual(viewController.changes, 2)
        XCTAssertEqual(viewController.state!, .loading)
        XCTAssertEqual(service.lastQuery, "test")

        service.fulfill(data:[
            Place(placeId: "1", displayName: "Test1", lat: "10", lon: "10"),
            Place(placeId: "2", displayName: "Test2", lat: "20", lon: "20"),
            Place(placeId: "3", displayName: "Test3", lat: "30", lon: "30"),
            ])

        let predicate = NSPredicate(format: "changes > 2")
        let e = expectation(for: predicate, evaluatedWith: viewController, handler: nil)
        wait(for: [e], timeout: 1)
        XCTAssertEqual(viewController.changes, 3)
        XCTAssertEqual(viewController.state!, .rows([
            SearchCellViewModel(title: "Test1", subtitle: "10, 10"),
            SearchCellViewModel(title: "Test2", subtitle: "20, 20"),
            SearchCellViewModel(title: "Test3", subtitle: "30, 30"),
            ]))
    }
}
