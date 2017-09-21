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
    
}
