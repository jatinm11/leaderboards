//
//  AppDelegate.swift
//  Leaderboards
//
//  Created by Jatin Menghani on 19/09/17.
//  Copyright © 2017 Jatin Menghani. All rights reserved.
//

import UIKit
import UserNotifications
import CloudKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        UINavigationBar.appearance().tintColor = .white
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert]) { (granted, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        PlayerController.shared.fetchCurrentPlayer { (success) in
            DispatchQueue.main.async {
                if success {
                    guard let currentPlayer = PlayerController.shared.currentPlayer else { return }
                    
                    let currentPlayerIsParticipantPredicate = NSPredicate(format: "participants CONTAINS %@", CKReference(recordID: currentPlayer.recordID, action: .none))
                    let matchIsNotVerifiedPredicate = NSPredicate(format: "verified == false")
                    let currentPlayerIsNotCreatorPredicate = NSPredicate(format: "creator != %@", CKReference(recordID: currentPlayer.recordID, action: .none))
                    
                    let pendingMatchesForCurrentPlayerCompoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [currentPlayerIsParticipantPredicate, matchIsNotVerifiedPredicate, currentPlayerIsNotCreatorPredicate])
                    
                    let subscription = CKQuerySubscription(recordType: Match.recordType, predicate: pendingMatchesForCurrentPlayerCompoundPredicate, options: .firesOnRecordCreation)
                    
                    let notificationInfo = CKNotificationInfo()
                    notificationInfo.alertBody = "New pending match awaiting approval."
//                    notificationInfo.desiredKeys = ["creator", "game"]
//                    notificationInfo.alertLocalizationKey = "New message: %1$@, %2$@"
//                    notificationInfo.alertLocalizationArgs = ["creator", "game"]
                    notificationInfo.soundName = "default"
                    notificationInfo.shouldBadge = true
                    
                    subscription.notificationInfo = notificationInfo

                    CloudKitManager.shared.publicDB.save(subscription) { (_, error) in
                        if let error = error {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
        }

    }

}

