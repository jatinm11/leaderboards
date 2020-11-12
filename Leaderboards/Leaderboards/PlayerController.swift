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
    
    var currentPlayer: Player?
    
    var opponents = [Player]()
    
    func checkIfLoggedInToiCloud(completion: @escaping(_ status: iCloudStatus) -> Void) {
        
        CKContainer.default().accountStatus { (status, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            switch status.rawValue {
            case 0:
                print("Can't determine")
                completion(.notLoggedIn)
            case 1:
                completion(.loggedIn)
                
            case 2:
                print("Restricted")
                completion(.notLoggedIn)
            case 3:
                print("Account not logged in")
                completion(.notLoggedIn)
            default:
                print("ignore this !")
            }
        }
    }
    
    func createPlayerWith(username: String, photo: UIImage?, completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        
        CKContainer.default().fetchUserRecordID { (appleUsersRecordID, error) in
            
            guard let appleUsersRecordID = appleUsersRecordID else { completion(false, error); return }
            
            let appleUserRef = CKRecord.Reference(recordID: appleUsersRecordID, action: .deleteSelf)
            
            let player = Player(recordID: CKRecord.ID(recordName: UUID().uuidString), playspaces: [], username: username, photo: photo, appleUserRef: appleUserRef)
            
            let playerRecord = player.CKRepresentation
            
            CloudKitManager.shared.saveRecord(playerRecord) { (record, error) in
                if let error = error { print(error.localizedDescription) }
                
                guard let record = record,
                      let currentPlayer = Player(record: record) else { completion(false, error); return }
                
                let tempURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(record.recordID.recordName + ".dat")
                try? FileManager.default.removeItem(at: tempURL)
                self.currentPlayer = currentPlayer
                
                completion(true, nil)
            }
        }
    }
    
    func fetchCurrentPlayer(completion: @escaping (_ success: Bool) -> Void = { _ in }) {
        // Fetch default Apple 'Users' recordID
        
        CKContainer.default().fetchUserRecordID { (appleUserRecordID, error) in
            
            if let error = error { completion(false); print(error.localizedDescription); return }
            
            guard let appleUserRecordID = appleUserRecordID else { print("HERE 12"); completion(false); return }
            
            // Create a CKReference with the Apple 'Users' recordID so that we can fetch OUR cust user record
            let appleUserReference = CKRecord.Reference(recordID: appleUserRecordID, action: .deleteSelf)
            
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
    
    func updatePlayer(_ player: Player, completion: @escaping (_ success: Bool) -> Void = { _ in }) {
        let playerRecord = player.CKRepresentation
        CloudKitManager.shared.updateRecords([playerRecord], perRecordCompletion: nil) { (_, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
                return
            }
            let tempURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(player.recordID.recordName + ".dat")
            try? FileManager.default.removeItem(at: tempURL)
            completion(true)
        }
    }
    
    func fetchPlayspacesFor(_ player: Player, completion: @escaping (_ success: Bool) -> Void = { _ in }) {
        var playspaceRecordIDs = [CKRecord.ID]()
        
        for playspace in player.playspaces {
            playspaceRecordIDs.append(playspace.recordID)
        }
        
        CloudKitManager.shared.fetchRecords(withIDs: playspaceRecordIDs) { (playspacesDictionary, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
                return
            }
            
            var playspaceRecords = [CKRecord]()
            guard let playspacesDictionary = playspacesDictionary else { completion(false); return }
            for playspaceRecord in playspacesDictionary.values {
                playspaceRecords.append(playspaceRecord)
            }
            
            let playspaces = playspaceRecords.compactMap({ Playspace(record: $0 ) })
//            let playspaces = pcompactMapeRecords.compactMap { Playspace(record: $0) }
            PlayspaceController.shared.playspaces = playspaces
            completion(true)
        }
    }
    
    func fetchPlayersFor(_ playspace: Playspace, completion: @escaping (_ players: [Player]?, _ success: Bool) -> Void = { _, _ in }) {
        let playerIsInPlayspacePredicate = NSPredicate(format: "playspaces CONTAINS %@", playspace.recordID)
        
        let query = CKQuery(recordType: Player.recordType, predicate: playerIsInPlayspacePredicate)
        query.sortDescriptors = [NSSortDescriptor(key: "username", ascending: true)]
        
        
        CloudKitManager.shared.publicDB.perform(query, inZoneWith: nil) { (playerRecords, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(nil, false)
                return
            }
            
            guard let playerRecords = playerRecords else { completion(nil, false); return }
            let compactMapRecords = playerRecords.compactMap({ Player(record: $0) })
            completion(compactMapRecords, true)
        }
        
//        CloudKitManager.shared.fetchRecordsWithType(Player.recordType, predicate: playerIsInPlayspacePredicate, recordFetchedBlock: nil) { (playerRecords, error) in
//            if let error = error {
//                print(error.localizedDescription)
//                completion(nil, false)
//                return
//            }
//
//            guard let playerRecords = playerRecords else { completion(nil, false); return }
//            let players = playerRecords.flatMap { Player(record: $0) }
//            completion(players, true)
//        }
    }
    
    func fetchPlayer(_ playerRecordID: CKRecord.ID, completion: @escaping (_ player: Player?, _ success: Bool) -> Void = { _,_  in }) {
        
        CloudKitManager.shared.fetchRecord(withID: playerRecordID) { (record, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(nil, false)
                return
            }
            
            guard let record = record else { completion(nil, false); return }
            completion(Player(record: record), true)
        }
    }
    
}

enum iCloudStatus {
    case loggedIn
    case notLoggedIn
}
