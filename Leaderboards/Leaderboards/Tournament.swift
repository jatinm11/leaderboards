//
//  Tournament.swift
//  Leaderboards
//
//  Created by Mithun Reddy on 9/25/17.
//  Copyright © 2017 Jatin Menghani. All rights reserved.
//

import Foundation
import CloudKit

struct Tournament {
    
    let recordID: CKRecordID
    let name: String
    let game: CKReference
    var players: [CKReference]
    var playersAlive: [CKReference]
    var matches: [CKReference]
    var matchPartners: [CKReference]
    var inProgress: Bool
    let creator: CKReference
    
}

// MARK: - CloudKit

extension Tournament {
    
    static let nameKey = "name"
    static let gameKey = "game"
    static let playersKey = "players"
    static let playersAliveKey = "playersAlive"
    static let matchesKey = "matches"
    static let matchPartnersKey = "matchPartners"
    static let inProgressKey = "inProgress"
    static let creatorKey = "creator"
    static let recordType = "Tournament"
    
    init?(record: CKRecord) {
        guard let name = record[Tournament.nameKey] as? String,
            let game = record[Tournament.gameKey] as? CKReference,
            let inProgress = record[Tournament.inProgressKey] as? Bool,
            let creator = record[Tournament.creatorKey] as? CKReference else { return nil }
        
        self.recordID = record.recordID
        self.name = name
        self.game = game
        
        if let players = record[Tournament.playersKey] as? [CKReference] {
            self.players = players
        } else {
            self.players = []
        }
        
        if let playersAlive = record[Tournament.playersAliveKey] as? [CKReference] {
            self.playersAlive = playersAlive
        } else {
            self.playersAlive = []
        }
        
        if let matches = record[Tournament.matchesKey] as? [CKReference] {
            self.matches = matches
        } else {
            self.matches = []
        }
        
        if let matchPartners = record[Tournament.matchPartnersKey] as? [CKReference] {
            self.matchPartners = matchPartners
        } else {
            self.matchPartners = []
        }
        
        self.inProgress = inProgress
        self.creator = creator
    }
    
    var CKRepresentation: CKRecord {
        let record = CKRecord(recordType: Tournament.recordType, recordID: recordID)
        
        record.setValue(name, forKey: Tournament.nameKey)
        record.setValue(game, forKey: Tournament.gameKey)
        record.setValue(players, forKey: Tournament.playersKey)
        record.setValue(playersAlive, forKey: Tournament.playersAliveKey)
        record.setValue(matches, forKey: Tournament.matchesKey)
        record.setValue(matchPartners, forKey: Tournament.matchPartnersKey)
        record.setValue(inProgress, forKey: Tournament.inProgressKey)
        record.setValue(creator, forKey: Tournament.creatorKey)
        
        return record
    }
    
}
