//
//  TournamentController.swift
//  Leaderboards
//
//  Created by Mithun Reddy on 9/25/17.
//  Copyright © 2017 Jatin Menghani. All rights reserved.
//

import Foundation
import CloudKit
import GameKit

class TournamentController {
    
    static let shared = TournamentController()
    
    var currentTournament: Tournament?
    
    func createTournamentWith(name: String, completion: @escaping (_ success: Bool) -> Void = { _ in }) {
        guard let currentPlayer = PlayerController.shared.currentPlayer,
            let currentGame = GameController.shared.currentGame else { completion(false); return }
        
        let tournament = Tournament(recordID: CKRecordID(recordName: UUID().uuidString), name: name, game: CKReference(recordID: currentGame.recordID, action: .none), players: [CKReference(recordID: currentPlayer.recordID, action: .none)], playersAlive: [CKReference(recordID: currentPlayer.recordID, action: .none)], matches: [], matchPartners: [], inProgress: false, creator: CKReference(recordID: currentPlayer.recordID, action: .none))
        
        CloudKitManager.shared.saveRecord(tournament.CKRepresentation) { (record, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
                return
            }
            
            guard let tournamentRecord = record else { completion(false); return }
            self.currentTournament = Tournament(record: tournamentRecord)
            completion(true)
        }
    }
    
    func refreshCurrentTournament(completion: @escaping (_ success: Bool) -> Void = { _ in }) {
        guard let currentTournament = currentTournament else { completion(false); return }
        
        CloudKitManager.shared.fetchRecord(withID: currentTournament.recordID) { (record, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
                return
            }
            
            guard let tournamentRecord = record else { completion(false); return }
            self.currentTournament = Tournament(record: tournamentRecord)
            completion(true)
        }
    }
    
    func startCurrentTournament(completion: @escaping (_ success: Bool) -> Void = { _ in }) {
        guard var currentTournament = currentTournament else { completion(false); return }
        
        if currentTournament.players.count >= 1 {
            currentTournament.inProgress = true
            
            let matchPartners = createMatchPartnersFor(currentTournament)
            currentTournament.matchPartners = Array(matchPartners.joined())
            
            CloudKitManager.shared.updateRecords([currentTournament.CKRepresentation], perRecordCompletion: nil) { (records, error) in
                if let error = error {
                    print(error.localizedDescription)
                    completion(false)
                    return
                }
                
                guard let records = records, let tournamentRecord = records.first else { completion(false); return }
                self.currentTournament = Tournament(record: tournamentRecord)
                completion(true)
                return
            }
        }
        
        completion(false)
    }
    
    func createMatchPartnersFor(_ tournament: Tournament) -> [[CKReference]] {
        guard var randomizedPlayersAlive = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: tournament.playersAlive) as? [CKReference] else { return [] }
        
        let powerOfTwo = smallestPowerOfTwoGreaterThanOrEqualTo(randomizedPlayersAlive.count)
        let numberOfMatches = (randomizedPlayersAlive.count * 2) - powerOfTwo
        
        var matchPartners = [[CKReference]]()
        for i in 0..<numberOfMatches {
            matchPartners[i] = [randomizedPlayersAlive[0], randomizedPlayersAlive[1]]
            randomizedPlayersAlive.remove(at: 0)
            randomizedPlayersAlive.remove(at: 1)
        }
        
        return matchPartners
    }
    
    func smallestPowerOfTwoGreaterThanOrEqualTo(_ n: Int) -> Int {
        for i in 1...Int.max {
            if n <= 2^i {
                return 2^i
            }
        }
        return 0
    }
    
}
