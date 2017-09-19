//
//  PlayerController.swift
//  Leaderboards
//
//  Created by Mithun Reddy on 9/19/17.
//  Copyright © 2017 Jatin Menghani. All rights reserved.
//

import UIKit
import CloudKit

class PlayerController {
    
    static let shared = PlayerController()
    
    let currentPlayerWasSetNotification = Notification.Name("currentPlayerWasSet")
    
    var currentPlayer: Player? {
        didSet {
            
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: self.currentPlayerWasSetNotification, object: nil)
            }
        }
    }
    
    func createPlayerWith(username: String, photo: UIImage?, completion: @escaping (_ success: Bool) -> Void) {
        CKContainer.default().fetchUserRecordID { (appleUsersRecordID, error) in
            guard let appleUsersRecordID = appleUsersRecordID else { completion(false); return }
            let appleUserRef = CKReference(recordID: appleUsersRecordID, action: .deleteSelf)
            
            let player = Player(recordID: CKRecordID(recordName: UUID().uuidString), playspaces: [], username: username, photo: photo, appleUserRef: appleUserRef)
            
            let playerRecord = player.CKRepresentation
            
            CKContainer.default().publicCloudDatabase.save(playerRecord) { (record, error) in
                if let error = error { print(error.localizedDescription) }
                
                guard let record = record,
                    let currentPlayer = Player(record: record) else { completion(false); return }
                
                self.currentPlayer = currentPlayer
                completion(true)
            }
        }
        
    }
    
    func fetchCurrentPlayer(completion: @escaping (_ success: Bool) -> Void = { _ in }) {
        // Fetch default Apple 'Users' recordID
        
        CKContainer.default().fetchUserRecordID { (appleUserRecordID, error) in
            if let error = error { print(error.localizedDescription) }
            guard let appleUserRecordID = appleUserRecordID else { completion(false); return }
            
            // Create a CKReference with the Apple 'Users' recordID so that we can fetch OUR cust user record
            let appleUserReference = CKReference(recordID: appleUserRecordID, action: .deleteSelf)
            
            // Create a predicate with the reference that was just created.
            // This predicate will search through all the Users and filter them based on a matching reference
            let predicate = NSPredicate(format: "appleUserRef == %@", appleUserReference)
            
            // Perform the fetch on our 'User' record
            CloudKitManager.shared.fetchRecordsWithType(Player.recordType, predicate: predicate, recordFetchedBlock: nil, completion: { (records, error) in
                guard let currentPlayerRecord = records?.first else { completion(false); return }
                let currentPlayer = Player(record: currentPlayerRecord)
                self.currentPlayer = currentPlayer
                completion(true)
            })
        }
    }
    
}
