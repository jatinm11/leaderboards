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
    var matchesInCurrentGame = [Match]()
    
    
    
    func createMatch(game: Game, winner: Player, winnerScore: Int, loser: Player, loserScore: Int, completion: @escaping (_ success: Bool) -> Void) {
        guard let creator = PlayerController.shared.currentPlayer else { completion(false); return }
        
        var scoreString = ""
        if winner.recordID == creator.recordID {
            scoreString = "\(loserScore) - \(winnerScore) loss"
        } else {
            scoreString = "\(winnerScore) - \(loserScore) win"
        }
        
        let match = Match(recordID: CKRecordID(recordName: UUID().uuidString), game: CKReference(record: game.CKRepresentation, action: .none), winner: CKReference(record: winner.CKRepresentation, action: .none), winnerScore: winnerScore, loser: CKReference(record: loser.CKRepresentation, action: .none), loserScore: loserScore, verified: false, timestamp: Date(), creator: CKReference(record: creator.CKRepresentation, action: .none), participants: [CKReference(record: winner.CKRepresentation, action: .none), CKReference(record: loser.CKRepresentation, action: .none)], creatorString: "\(creator.username.uppercased())", scoreString: scoreString.uppercased(), gameString: "\(game.name.uppercased())")
        
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
        
        let currentPlayerIsParticipantPredicate = NSPredicate(format: "participants CONTAINS %@", currentPlayer.CKRepresentation)
        let matchIsNotVerifiedPredicate = NSPredicate(format: "verified == false")
        let currentPlayerIsNotCreatorPredicate = NSPredicate(format: "creator != %@", currentPlayer.CKRepresentation)
        
        let pendingMatchesForCurrentPlayerCompoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [currentPlayerIsParticipantPredicate, matchIsNotVerifiedPredicate, currentPlayerIsNotCreatorPredicate])
        
        let query = CKQuery(recordType: Match.recordType, predicate: pendingMatchesForCurrentPlayerCompoundPredicate)
        query.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        
        
        CloudKitManager.shared.publicDB.perform(query, inZoneWith: nil) { (records, error) in
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
        
        //        CloudKitManager.shared.fetchRecordsWithType(Match.recordType, predicate: pendingMatchesForCurrentPlayerCompoundPredicate, recordFetchedBlock: nil) { (records, error) in
        //            if let error = error {
        //                print(error.localizedDescription)
        //                completion(false)
        //                return
        //            }
        //
        //            guard let pendingMatchRecords = records else { completion(false); return }
        //            let pendingMatches = pendingMatchRecords.flatMap { Match(record: $0) }
        //
        //            self.pendingMatches = pendingMatches
        //            completion(true)
        //        }
    }
    
    func fetchMatchesForCurrentPlayer(completion: @escaping (_ matches: [Match]?, _ success: Bool) -> Void = { _, _ in }) {
        guard let currentPlayer = PlayerController.shared.currentPlayer else { completion(nil, false); return }
        
        let currentPlayerIsParticipantPredicate = NSPredicate(format: "participants CONTAINS %@", currentPlayer.CKRepresentation)
        let matchIsVerifiedPredicate = NSPredicate(format: "verified == true")
        
        let matchesForCurrentPlayerCompoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [currentPlayerIsParticipantPredicate, matchIsVerifiedPredicate])
        
        let query = CKQuery(recordType: Match.recordType, predicate: matchesForCurrentPlayerCompoundPredicate)
        query.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        
        
        CloudKitManager.shared.publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(nil, false)
                return
            }
            
            guard let matchRecords = records else { completion(nil, false); return }
            let matches = matchRecords.flatMap { Match(record: $0) }
            
            completion(matches, true)
        }
        
        //        CloudKitManager.shared.fetchRecordsWithType(Match.recordType, predicate: matchesForCurrentPlayerCompoundPredicate, recordFetchedBlock: nil) { (records, error) in
        //            if let error = error {
        //                print(error.localizedDescription)
        //                completion(nil, false)
        //                return
        //            }
        //
        //            guard let matchRecords = records else { completion(nil, false); return }
        //            let matches = matchRecords.flatMap { Match(record: $0) }
        //
        //            completion(matches, true)
        //        }
    }
    
    func fetchGameAndOpponentFor(_ match: Match, completion: @escaping (_ game: Game?, _ opponent: Player?, _ success: Bool) -> Void = { _,_,_  in }) {
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
    
    
    func fetchOpponentImageFor(_ match: Match, completion: @escaping (_ opponent: Player?, _ success: Bool) -> Void = { _,_  in }) {
        let opponentRecordID = match.creator.recordID
        
        CloudKitManager.shared.fetchRecord(withID: opponentRecordID) { (record, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(nil, false)
                return
            }
            
            guard let record = record else { completion(nil, false); return }
            completion(Player(record: record), true)
            
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
    
    func fetchMatchesForCurrentGame(completion: @escaping (_ success: Bool) -> Void = { _ in }) {
        guard let currentGame = GameController.shared.currentGame else { completion(false); return }
        
        let matchIsForCurrentGamePredicate = NSPredicate(format: "game == %@", currentGame.recordID)
        let matchIsVerifiedPredicate = NSPredicate(format: "verified == true")
        
        let matchCompoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [matchIsForCurrentGamePredicate, matchIsVerifiedPredicate])
        
        CloudKitManager.shared.fetchRecordsWithType(Match.recordType, predicate: matchCompoundPredicate, recordFetchedBlock: nil) { (records, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
                return
            }
            
            guard let matchRecords = records else { completion(false); return }
            
            let matches = matchRecords.flatMap( { Match(record: $0) })
            self.matchesInCurrentGame = matches
            completion(true)
        }
    }
    
    func fetchMatchesForGame(_ game: Game, andPlayer player: Player, completion: @escaping (_ matches: [Match]?, _ success: Bool) -> Void = { _, _  in }) {
        let matchIsForCurrentGamePredicate = NSPredicate(format: "game == %@", game.recordID)
        let matchIsVerifiedPredicate = NSPredicate(format: "verified == true")
        let matchIncludesPlayerPredicate = NSPredicate(format: "participants CONTAINS %@", player.recordID)
        
        let matchCompoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [matchIsForCurrentGamePredicate, matchIsVerifiedPredicate, matchIncludesPlayerPredicate])
        
        
        let query = CKQuery(recordType: Match.recordType, predicate: matchCompoundPredicate)
        query.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        
        
        CloudKitManager.shared.publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(nil, false)
                return
            }
            
            guard let matchRecords = records else { completion(nil, false); return }
            let matches = matchRecords.flatMap { Match(record: $0) }
            
            completion(matches, true)
        }
        
        
        
        
        //        CloudKitManager.shared.fetchRecordsWithType(Match.recordType, predicate: matchCompoundPredicate, recordFetchedBlock: nil) { (records, error) in
        //            if let error = error {
        //                print(error.localizedDescription)
        //                completion(nil, false)
        //                return
        //            }
        //
        //            guard let matchRecords = records else { completion(nil, false); return }
        //
        //            let matches = matchRecords.flatMap( { Match(record: $0) })
        //            completion(matches, true)
        //        }
    }
    
    func fetchOpponentsForMatches(_ matches: [Match], player: Player, completion: @escaping (_ opponents: [Player]?, _ success: Bool) -> Void = { _, _  in }) {
        var opponentRecordIDs = [CKRecordID]()
        for match in matches {
            for playerReference in match.participants {
                if playerReference.recordID != player.recordID {
                    opponentRecordIDs.append(playerReference.recordID)
                }
            }
        }
        
        CloudKitManager.shared.fetchRecords(withIDs: opponentRecordIDs) { (opponentRecordsDict, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(nil, false)
                return
            }
            
            var opponents = [Player]()
            guard let opponentRecordsDict = opponentRecordsDict else { completion(nil, false); return }
            for opponentRecordID in opponentRecordIDs {
                if let opponentRecord = opponentRecordsDict[opponentRecordID],
                    let opponent = Player(record: opponentRecord) {
                    opponents.append(opponent)
                }
            }
            completion(opponents, true)
        }
    }
    
    func fetchGamesForMatches(_ matches: [Match], completion: @escaping (_ games: [Game]?, _ success: Bool) -> Void = { _, _  in }) {
        var gameRecordIDs = [CKRecordID]()
        for match in matches {
            gameRecordIDs.append(match.game.recordID)
        }
        
        CloudKitManager.shared.fetchRecords(withIDs: gameRecordIDs) { (gameRecordsDict, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(nil, false)
                return
            }
            
            var games = [Game]()
            guard let gameRecordsDict = gameRecordsDict else { completion(nil, false); return }
            for gameRecordID in gameRecordIDs {
                if let gameRecord = gameRecordsDict[gameRecordID],
                    let game = Game(record: gameRecord) {
                    games.append(game)
                }
            }
            completion(games, true)
        }
    }
    
}
