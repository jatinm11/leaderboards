//
//  LeaderboardsController.swift
//  Leaderboards
//
//  Created by Jatin Menghani on 19/09/17.
//  Copyright © 2017 Jatin Menghani. All rights reserved.
//

import Foundation
import CloudKit

class MatchController {
    
    static let shared = MatchController()
    
    var pendingMatches = [Match]()
    
    func createMatch(game: Game, winner: Player, winnerScore: Int, loser: Player, loserScore: Int, completion: @escaping (_ success: Bool) -> Void) {
        guard let creator = PlayerController.shared.currentPlayer else { completion(false); return }
        
        let match = Match(recordID: CKRecordID(recordName: UUID().uuidString), game: CKReference(record: game.CKRepresentation, action: .none), winner: CKReference(record: winner.CKRepresentation, action: .none), winnerScore: winnerScore, loser: CKReference(record: loser.CKRepresentation, action: .none), loserScore: loserScore, verified: false, timestamp: Date(), creator: CKReference(record: creator.CKRepresentation, action: .none))
        
        CloudKitManager.shared.saveRecord(match.CKRepresentation) { (_, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
                return
            }
            
            completion(true)
        }
    }
    
    func fetchPendingMatchesForCurrentPlayer(completion: @escaping (_ success: Bool) -> Void = { _ in }) {
        guard let currentPlayer = PlayerController.shared.currentPlayer else { completion(false); return }
        
        let currentPlayerIsWinnerPredicate = NSPredicate(format: "winner == %@", currentPlayer.CKRepresentation)
        let currentPlayerIsLoserPredicate = NSPredicate(format: "loser == %@", currentPlayer.CKRepresentation)
        let matchIsNotVerifiedPredicate = NSPredicate(format: "verified == false")
        let currentPlayerIsNotCreatorPredicate = NSPredicate(format: "creator != %@", currentPlayer.CKRepresentation)
        
        let pendingMatchesForCurrentPlayerCompoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [currentPlayerIsWinnerPredicate, matchIsNotVerifiedPredicate, currentPlayerIsNotCreatorPredicate])
        
        CloudKitManager.shared.fetchRecordsWithType(Match.recordType, predicate: pendingMatchesForCurrentPlayerCompoundPredicate, recordFetchedBlock: nil) { (records, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
                return
            }
            
            guard let pendingMatchRecords = records else { completion(false); return }
            let pendingMatches = pendingMatchRecords.flatMap { Match(record: $0) }
            
            self.pendingMatches = pendingMatches
            completion(true)
        }
    }
    
    func fetchGameAndOpponentFor(_ match: Match, completion: @escaping (_ game: Game?, _ opponent: Player?, _ success: Bool) -> Void = { _ in }) {
        let gameRecordID = match.game.recordID
        let opponentRecordID = match.creator.recordID
        
        CloudKitManager.shared.fetchRecords(withIDs: [gameRecordID, opponentRecordID]) { (gameOpponentDictionary, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(nil, nil, false)
                return
            }
            
            guard let gameOpponentDictionary = gameOpponentDictionary,
                let gameRecord = gameOpponentDictionary[gameRecordID],
                let opponentRecord = gameOpponentDictionary[opponentRecordID],
                let game = Game(record: gameRecord),
                let opponent = Player(record: opponentRecord) else { completion(nil, nil, false); return }
            
            completion(game, opponent, true)
        }
    }
    
    func verifyMatch(_ match: Match) -> Match {
        var match = match
        match.verified = true
        return match
    }
    
    func updateMatch(_ match: Match, completion: @escaping (_ success: Bool) -> Void = { _ in }) {
        let matchRecord = match.CKRepresentation
        
        CloudKitManager.shared.updateRecords([matchRecord], perRecordCompletion: nil) { (_, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
                return
            }
            
            completion(true)
        }
    }
    
    func clearPendingMatch(at index: Int) {
        pendingMatches.remove(at: index)
    }
    
    func deletePendingMatch(at index: Int, completion: @escaping (_ success: Bool) -> Void = { _ in }) {
        let deletedPendingMatch = pendingMatches[index]

        CloudKitManager.shared.deleteRecordWithID(deletedPendingMatch.recordID) { (_, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
                return
            }
            
            completion(true)
        }
    }
}
