//
//  Game.swift
//  Leaderboards
//
//  Created by Mithun Reddy on 9/18/17.
//  Copyright © 2017 Jatin Menghani. All rights reserved.
//

import Foundation
import CloudKit

struct Game {
    
    let recordID: CKRecordID
    let name: String
    let playspace: CKReference
    
}

// MARK: - CloudKit

extension Game {
    
    static let nameKey = "name"
    static let playspaceKey = "playspace"
    static let recordType = "Game"
    
    init?(record: CKRecord) {
        guard let name = record[Game.nameKey] as? String,
            let playspace = record[Game.playspaceKey] as? CKReference else { return nil }
        
        self.recordID = record.recordID
        self.name = name
        self.playspace = playspace
    }
    
    var CKRepresentation: CKRecord {
        let record = CKRecord(recordType: Game.recordType, recordID: recordID)
        
        record.setValue(name, forKey: Game.nameKey)
        record.setValue(playspace, forKey: Game.playspaceKey)
        
        return record
    }
    
}
