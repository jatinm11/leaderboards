//
//  Player.swift
//  Leaderboards
//
//  Created by jonathan orellana on 9/18/17.
//  Copyright © 2017 Jatin Menghani. All rights reserved.
//

import UIKit
import CloudKit

struct Player {
    
    let recordID: CKRecordID
    var playspaces: [CKReference]
    let username: String
    let photo: UIImage?
    let appleUserRef: CKReference
    
    var photoAsset: CKAsset? {
        do {
            guard let photo = photo else { return nil }
            let data = UIImagePNGRepresentation(photo)
            let tempURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(UUID().uuidString + ".dat")
            try data?.write(to: tempURL)
            let asset = CKAsset(fileURL: tempURL)
            return asset
        } catch {
            print("Error writing photo data", error)
        }
        return nil
    }
    
}

// MARK: CloudKit

extension Player {
    
    static let playspacesKey = "playspaces"
    static let recordType = "Player"
    static let usernameKey = "username"
    static let photoKey = "photo"
    static let appleUserRefKey = "appleUserRef"
    
    init?(record: CKRecord) {
        guard let username = record[Player.usernameKey] as? String,
            let appleUserRef = record[Player.appleUserRefKey] as? CKReference else { return nil }
        
        self.recordID = record.recordID
        
        if let playspaces = record[Player.playspacesKey] as? [CKReference] {
            self.playspaces = playspaces
        } else {
            self.playspaces = []
        }
        
        self.username = username
        
        if let photoAsset = record[Player.photoKey] as? CKAsset, let photoData = try? Data(contentsOf: photoAsset.fileURL) {
            let photo = UIImage(data: photoData)
            self.photo = photo
        } else {
            self.photo = nil
        }
        
        self.appleUserRef = appleUserRef
    }
    
    var CKRepresentation: CKRecord {
        let record = CKRecord(recordType: Player.recordType, recordID: recordID)
        
        if playspaces.count == 0 {
            record.setValue(nil, forKey: Player.playspacesKey)
        } else {
            record.setValue(playspaces, forKey: Player.playspacesKey)
        }
        record.setValue(username, forKey: Player.usernameKey)
        record.setValue(photoAsset, forKey: Player.photoKey)
        record.setValue(appleUserRef, forKey: Player.appleUserRefKey)

        
        return record
        
    }
}
