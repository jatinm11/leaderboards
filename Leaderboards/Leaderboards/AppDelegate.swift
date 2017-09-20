//
//  AppDelegate.swift
//  Leaderboards
//
//  Created by Jatin Menghani on 19/09/17.
//  Copyright © 2017 Jatin Menghani. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        PlayerController.shared.fetchCurrentPlayer()
        
        return true
    }

}

