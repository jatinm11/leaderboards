//
//  PlayspaceController.swift
//  Leaderboards
//
//  Created by jonathan orellana on 9/19/17.
//  Copyright © 2017 Jatin Menghani. All rights reserved.
//

import Foundation
import CloudKit

class PlayspaceController {
    
    static let shared = PlayspaceController()
    
    fileprivate static let playspaceKey = "playspace"
    
    var playspaces: [Playspace] = []
    
    var currentPlayspace: Playspace?
    
    func createPlayspaceWith(name: String) {
        let playspace = Playspace(recordID: CKRecordID(recordName: UUID().uuidString), name: name, password: randomString(length: 4))
        
        CloudKitManager.shared.saveRecord(playspace.CKRepresentation, completion: nil)
        
        if let currentPlayer = PlayerController.shared.currentPlayer {
            addPlayer(currentPlayer, toPlayspaceRecord: playspace.CKRepresentation)
        }
    }
    
    func joinPlayspaceWith(password: String, completion: @escaping (_ success: Bool) -> Void = { _ in }) {
        let predicate = NSPredicate(format: "password == %@", password)
        CloudKitManager.shared.fetchRecordsWithType(Playspace.recordType, predicate: predicate, recordFetchedBlock: nil) { (records, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
                return
            }
            
            guard let currentPlayer = PlayerController.shared.currentPlayer, let records = records else { completion(false); return }
            self.addPlayer(currentPlayer, toPlayspaceRecord: records[0])
            completion(true)
        }
    }
    
    func addPlayer(_ player: Player, toPlayspaceRecord playspaceRecord: CKRecord) {
        var player = player
        player.playspaces.append(CKReference(record: playspaceRecord, action: .none))
        PlayerController.shared.updatePlayer(player) { (success) in
            if success {
                PlayerController.shared.fetchCurrentPlayer()
            }
        }
    }
    
    
    
    func randomString(length:Int) -> String {
        let charSet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var c = charSet.characters.map { String($0) }
        var s:String = ""
        for _ in (1...length) {
            s.append(c[Int(arc4random()) % c.count])
        }
        return s
    }
}
