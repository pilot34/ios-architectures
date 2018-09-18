//
//  SearchServiceTests.swift
//  MVVMTests
//
//  Created by  Gleb Tarasov on 09/08/2018.
//  Copyright © 2018 Gleb Tarasov. All rights reserved.
//

import XCTest
import PromiseKit
@testable import MVP

class SearchServiceTests: XCTestCase {

    func testParsing() {
        let client = MockAPIClient(file: "places")
        let service = SearchService(client: client)
        let e = expectation(description: "test")
        service.search(query: "blabla")
            .done { places in
                XCTAssertTrue(places.count > 0)
                let place = places.first!
                XCTAssertEqual(place.displayName,  "Barnes & Noble Cafe, 235, Daniel Webster Highway, South Nashua, Ward 7, Nashua, Hillsborough County, New Hampshire, 03060, United States of America")
                XCTAssertEqual(place.lat, "42.710832")
                XCTAssertEqual(place.lon, "-71.4429025")
                e.fulfill()
            }
            .catch { _ in
                XCTFail("should be error")
        }

        client.fulfill()
        waitForExpectations(timeout: 1)
    }

    func testError() {
        let client = MockAPIClient(file: "places")
        let service = SearchService(client: client)
        let e = expectation(description: "test")
        service.search(query: "blabla")
            .done(on: DispatchQueue.main) { places in
                XCTFail("should be error")
            }
            .catch { _ in
                e.fulfill()
        }

        client.reject()
        waitForExpectations(timeout: 1)
    }
}

