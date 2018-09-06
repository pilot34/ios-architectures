//
//  SearchServiceTests.swift
//  MVVMTests
//
//  Created by  Gleb Tarasov on 09/08/2018.
//  Copyright © 2018 Gleb Tarasov. All rights reserved.
//

import XCTest
import RxTest
import RxSwift
import RxCocoa
@testable import MVVM

class SearchServiceTests: XCTestCase {

    private let scheduler = TestScheduler(initialClock: 0, simulateProcessingDelay: true)
    private let disposeBag = DisposeBag()

    func testParsing() {
        let client = MockAPIClient(file: "places")
        let service = SearchService(client: client)
        let observer = scheduler.createObserver([Place].self)

        service.search(query: "blabla")
            .asObservable()
            .subscribe(observer)
            .disposed(by: self.disposeBag)

        scheduler.start()
        XCTAssertEqual(2, observer.events.count)
        let places = observer.events.first?.value.element
        XCTAssertNotNil(places)
        XCTAssertTrue(places?.count ?? 0 > 0)

        let place = (places?.first)!
        XCTAssertEqual(place.displayName,  "Barnes & Noble Cafe, 235, Daniel Webster Highway, South Nashua, Ward 7, Nashua, Hillsborough County, New Hampshire, 03060, United States of America")
        XCTAssertEqual(place.lat, "42.710832")
        XCTAssertEqual(place.lon, "-71.4429025")
    }
}

