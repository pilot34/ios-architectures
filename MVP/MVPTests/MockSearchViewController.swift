//
//  MockSearchViewController.swift
//  MVPTests
//
//  Created by  Gleb Tarasov on 19/09/2018.
//  Copyright © 2018 Gleb Tarasov. All rights reserved.
//

import Foundation
@testable import MVP

class MockSearchViewController: NSObject, SearchViewControllerProtocol {
    func update(_ state: SearchPresenter.State, animated: Bool) {
        self.state = state
        changes += 1
    }

    @objc var changes: Int = 0
    var state: SearchPresenter.State?
}
