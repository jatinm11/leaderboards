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
    let winnerScore: Int
    let loser: CKReference
    let loserScore: Int
    var verified: Bool
    let timestamp: Date
    let creator: CKReference
    let participants: [CKReference]
    let creatorString: String
    let scoreString: String
    let gameString: String
    
}

// MARK: CloudKit

extension Match {
    
    static let timestampKey = "timestamp"
    static let verifiedKey = "verified"
    static let gameKey = "game"
    static let winnerKey = "winner"
    static let winnerScoreKey = "winnerScore"
    static let loserKey = "loser"
    static let loserScoreKey = "loserScore"
    static let creatorKey = "creator"
    static let participantsKey = "participants"
    static let creatorStringKey = "creatorString"
    static let scoreStringKey = "scoreString"
    static let gameStringKey = "gameString"
    static let recordType = "Match"
    
    init?(record: CKRecord) {
        guard let verified = record[Match.verifiedKey] as? Bool,
            let timestamp = record[Match.timestampKey] as? Date,
            let game = record[Match.gameKey] as? CKReference,
            let winner = record[Match.winnerKey] as? CKReference,
            let winnerScore = record[Match.winnerScoreKey] as? Int,
            let loser = record[Match.loserKey] as? CKReference,
            let loserScore = record[Match.loserScoreKey] as? Int,
            let creator = record[Match.creatorKey] as? CKReference,
            let participants = record[Match.participantsKey] as? [CKReference],
            let creatorString = record[Match.creatorStringKey] as? String,
            let scoreString = record[Match.scoreStringKey] as? String,
            let gameString = record[Match.gameStringKey] as? String else { return nil }
        
        self.recordID = record.recordID
        self.verified = verified
        self.timestamp = timestamp
        self.game = game
        self.winner = winner
        self.winnerScore = winnerScore
        self.loser = loser
        self.loserScore = loserScore
        self.creator = creator
        self.participants = participants
        self.creatorString = creatorString
        self.scoreString = scoreString
        self.gameString = gameString
    }
    
    var CKRepresentation: CKRecord {
        let record = CKRecord(recordType: Match.recordType, recordID: recordID)
        
        record.setValue(game, forKey: Match.gameKey)
        record.setValue(winner, forKey: Match.winnerKey)
        record.setValue(winnerScore, forKey: Match.winnerScoreKey)
        record.setValue(loser, forKey: Match.loserKey)
        record.setValue(loserScore, forKey: Match.loserScoreKey)
        record.setValue(verified, forKey: Match.verifiedKey)
        record.setValue(timestamp, forKey: Match.timestampKey)
        record.setValue(creator, forKey: Match.creatorKey)
        record.setValue(participants, forKey: Match.participantsKey)
        record.setValue(creatorString, forKey: Match.creatorStringKey)
        record.setValue(scoreString, forKey: Match.scoreStringKey)
        record.setValue(gameString, forKey: Match.gameStringKey)
        
        return record
    }
    
}

