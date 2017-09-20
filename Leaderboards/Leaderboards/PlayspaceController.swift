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
    
    func createPlayspaceWith(name: String) {
        let playspace = Playspace(recordID: CKRecordID(recordName: UUID().uuidString), name: name, password: randomString(length: 4))
        
        CloudKitManager.shared.saveRecord(playspace.CKRepresentation, completion: nil)
        
        if var currentPlayer = PlayerController.shared.currentPlayer {
            currentPlayer.playspaces.append(CKReference(record: playspace.CKRepresentation, action: .none))
            PlayerController.shared.updatePlayer(currentPlayer)
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
