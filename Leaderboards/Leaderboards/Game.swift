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
    
    let recordID: CKRecord.ID
    let name: String
    let playspace: CKRecord.Reference
    var players: [CKRecord.Reference]
    
}

// MARK: - CloudKit

extension Game {
    
    static let nameKey = "name"
    static let playspaceKey = "playspace"
    static let recordType = "Game"
    static let playersKey = "players"
    
    init?(record: CKRecord) {
        guard let name = record[Game.nameKey] as? String,
            let playspace = record[Game.playspaceKey] as? CKRecord.Reference else { return nil }
        
        self.recordID = record.recordID
        self.name = name
        self.playspace = playspace
        
        if let players = record[Game.playersKey] as? [CKRecord.Reference] {
            self.players = players
        } else {
            self.players = []
        }
    }
    
    var CKRepresentation: CKRecord {
        let record = CKRecord(recordType: Game.recordType, recordID: recordID)
        
        record.setValue(name, forKey: Game.nameKey)
        record.setValue(playspace, forKey: Game.playspaceKey)
        if players.count == 0 {
            record.setValue(nil, forKey: Game.playersKey)
        } else {
            record.setValue(players, forKey: Game.playersKey)
        }
        
        return record
    }
    
}


//
