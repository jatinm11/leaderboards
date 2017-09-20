//
//  MatchController.swift
//  Leaderboards
//
//  Created by Jatin Menghani on 20/09/17.
//  Copyright © 2017 Jatin Menghani. All rights reserved.
//

import Foundation
import CloudKit

class MatchController {
    
    static let shared = MatchController()
    
    var match: Match? {
        didSet {
            
        }
    }
    
    
    func createMatchWith(score1: Int, score2: Int, player1: String, player2: String, completion: @escaping (_ success: Bool) -> Void) {
        CKContainer.default().fetchUserRecordID { (matchRecordID, error) in
            if let error = error {
                print(error.localizedDescription) }
            
            guard let matchRecordID = matchRecordID else { completion(false); return }
            
            let matchRef = CKReference(recordID: matchRecordID, action: .none)
            
            
            let match = Match(recordID: CKRecordID(recordName: UUID().uuidString), game: <#T##CKReference#>, winner: <#T##CKReference#>, loser: <#T##CKReference#>, verified: <#T##Bool#>, timestamp: <#T##Date#>, creator: <#T##CKReference#>, score1: score1, score2: score2, player1: player1, player2: player2)
            let matchRecord = match.CKRepresentation
        
            CloudKitManager.shared.saveRecord(matchRecord, completion: { (record, error) in
                if let error = error {
                    print (error.localizedDescription)
                }
                
                guard let record = record, let match = Match(record: record) else { completion(false); return }
                
                self.match = match
                completion(true)
            })
        }
    }
    
}
