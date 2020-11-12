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


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
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
                    
                    let currentPlayerIsParticipantPredicate = NSPredicate(format: "participants CONTAINS %@", CKRecord.Reference(recordID: currentPlayer.recordID, action: .none))
                    let matchIsNotVerifiedPredicate = NSPredicate(format: "verified == false")
                    let currentPlayerIsNotCreatorPredicate = NSPredicate(format: "creator != %@", CKRecord.Reference(recordID: currentPlayer.recordID, action: .none))
                    
                    let pendingMatchesForCurrentPlayerCompoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [currentPlayerIsParticipantPredicate, matchIsNotVerifiedPredicate, currentPlayerIsNotCreatorPredicate])
                    
                    let subscription = CKQuerySubscription(recordType: Match.recordType, predicate: pendingMatchesForCurrentPlayerCompoundPredicate, options: .firesOnRecordCreation)
                    
                    let notificationInfo = CKSubscription.NotificationInfo()
                    notificationInfo.desiredKeys = ["creatorString", "scoreString", "gameString"]
                    notificationInfo.alertLocalizationKey = "New Pending Match: %1$@ submitted a %2$@ in %3$@"
                    notificationInfo.alertLocalizationArgs = ["creatorString", "scoreString", "gameString"]
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

