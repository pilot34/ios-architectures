//
//  MockSearchService.swift
//  MVVMTests
//
//  Created by  Gleb Tarasov on 08/09/2018.
//  Copyright © 2018 Gleb Tarasov. All rights reserved.
//

import Foundation
import PromiseKit
@testable import MVP

class MockSearchService: SearchServiceProtocol {

    enum TestError: LocalizedError {
        case error
        var errorDescription: String? {
            return "TestError"
        }
    }

    var lastQuery: String? = nil
    private let deferred = Promise<[Place]>.pending()

    func search(query: String) -> Promise<[Place]> {
        self.lastQuery = query
        return deferred.promise
    }

    func reject() {
        deferred.resolver.reject(TestError.error)
    }

    func fulfill(data: [Place]) {
        deferred.resolver.fulfill(data)
    }
}
