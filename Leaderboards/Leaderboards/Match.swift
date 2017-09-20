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
    let score1: Int
    let score2: Int
    let player1: String
    let player2: String
    
    
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
    static let score1Key = "score1"
    static let score2Key = "score2"
    static let player1Key = "player1"
    static let player2Key = "player2"
    
    init?(record: CKRecord) {
        guard let verified = record[Match.verifiedKey] as? Bool,
            let timestamp = record[Match.timestampKey] as? Date,
            let game = record[Match.gameKey] as? CKReference,
            let winner = record[Match.winnerKey] as? CKReference,
            let loser = record[Match.loserKey] as? CKReference,
            let creator = record[Match.creatorKey] as? CKReference,
            let score1 = record[Match.score1Key] as? Int,
            let score2 = record[Match.score2Key] as? Int,
            let player1 = record[Match.player1Key] as? String,
            let player2 = record[Match.player2Key] as? String else { return nil }
        
        self.recordID = record.recordID
        self.verified = verified
        self.timestamp = timestamp
        self.game = game
        self.winner = winner
        self.loser = loser
        self.creator = creator
        self.score1 = score1
        self.score2 = score2
        self.player1 = player1
        self.player2 = player2
    }
    
    var CKRepresentation: CKRecord {
        let record = CKRecord(recordType: Match.recordType, recordID: recordID)
        
        record.setValue(game, forKey: Match.gameKey)
        record.setValue(winner, forKey: Match.winnerKey)
        record.setValue(loser, forKey: Match.loserKey)
        record.setValue(verified, forKey: Match.verifiedKey)
        record.setValue(timestamp, forKey: Match.timestampKey)
        record.setValue(creator, forKey: Match.creatorKey)
        record.setValue(score1, forKey: Match.score1Key)
        record.setValue(score2, forKey: Match.score2Key)
        record.setValue(player1, forKey: Match.player1Key)
        record.setValue(player2, forKey: Match.player2Key)
        
        return record
    }
    
}

