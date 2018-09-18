//
//  AppDelegate.swift
//  MVP
//
//  Created by  Gleb Tarasov on 09/09/2018.
//  Copyright © 2018 Gleb Tarasov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let router = Router()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window?.rootViewController = router.rootViewController()
        return true
    }
}
