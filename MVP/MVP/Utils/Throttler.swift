//
//  Throttler.swift
//  MVP
//
//  Created by  Gleb Tarasov on 19/09/2018.
//  Copyright © 2018 Gleb Tarasov. All rights reserved.
//

import Foundation

public class Throttler {

    private var job: DispatchWorkItem = DispatchWorkItem(block: {})
    private var previousRun: Date = Date.distantPast
    private let maxInterval: TimeInterval

    public init(maxInterval: TimeInterval) {
        self.maxInterval = maxInterval
    }

    public func throttle(block: @escaping () -> Void) {
        job.cancel()
        job = DispatchWorkItem { [weak self] in
            self?.previousRun = Date()
            block()
        }
        let delay = Date().timeIntervalSince(previousRun) > maxInterval ? 0 : maxInterval
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(delay), execute: job)
    }

    public func fulfill() {
        job.perform()
        job.cancel()
    }
}
