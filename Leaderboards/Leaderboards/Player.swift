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
    let playspace: CKReference
    
}

// MARK: CloudKit

extension Player {
    
    static let playspaceKey = "playspace"
    static let recordType = "Player"
    
    init?(record: CKRecord) {
        guard let playspace = record[Player.playspaceKey] as? CKReference else { return nil }
        
        self.recordID = record.recordID
        self.playspace = playspace
    }
    
    var CKRepresentation: CKRecord {
        let record = CKRecord(recordType: Player.recordType, recordID: recordID)
        
        record.setValue(playspace, forKey: Player.playspaceKey)
        
        return record
        
    }
}
