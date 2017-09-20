//
//  Match.swift
//  Leaderboards
//
//  Created by jonathan orellana on 9/18/17.
//  Copyright © 2017 Jatin Menghani. All rights reserved.
//

import Foundation
import CloudKit

struct Match {
    
    let recordID: CKRecordID
    let game: CKReference
    let winner: CKReference
    let loser: CKReference
    var verified: Bool = false
    let timestamp: Date
    let creator: CKReference
    
    
}

// MARK: CloudKit

extension Match {
    
    static let timestampKey = "timestamp"
    static let verifiedKey = "verified"
    static let gameKey = "game"
    static let winnerKey = "winner"
    static let loserKey = "loser"
    static let creatorKey = "creator"
    static let recordType = "Match"
    
    init?(record: CKRecord) {
        guard let verified = record[Match.verifiedKey] as? Bool,
            let timestamp = record[Match.timestampKey] as? Date,
            let game = record[Match.gameKey] as? CKReference,
            let winner = record[Match.winnerKey] as? CKReference,
            let loser = record[Match.loserKey] as? CKReference,
            let creator = record[Match.creatorKey] as? CKReference else { return nil }
        
        self.recordID = record.recordID
        self.verified = verified
        self.timestamp = timestamp
        self.game = game
        self.winner = winner
        self.loser = loser
        self.creator = creator
    }
    
    var CKRepresentation: CKRecord {
        let record = CKRecord(recordType: Match.recordType, recordID: recordID)
        
        record.setValue(game, forKey: Match.gameKey)
        record.setValue(winner, forKey: Match.winnerKey)
        record.setValue(loser, forKey: Match.loserKey)
        record.setValue(verified, forKey: Match.verifiedKey)
        record.setValue(timestamp, forKey: Match.timestampKey)
        record.setValue(creator, forKey: Match.creatorKey)
        
        return record
    }
    
}

