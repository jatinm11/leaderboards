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
    
    func createPlayspaceWith(name: String, completion: @escaping (_ password: String?, _ success: Bool) -> Void = { _,_  in }) {
        let playspace = Playspace(recordID: CKRecordID(recordName: UUID().uuidString), name: name, password: randomString(length: 4))
        
        CloudKitManager.shared.saveRecord(playspace.CKRepresentation) { (_, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(nil, false)
                return
            }
            
            completion(playspace.password, true)
            
        }
        
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
            
            guard let currentPlayer = PlayerController.shared.currentPlayer, let records = records, records.count > 0 else { completion(false); return }
            self.addPlayer(currentPlayer, toPlayspaceRecord: records[0], completion: { (success) in
                if success {
                    completion(true)
                }
            })
        }
    }
    
    func addPlayer(_ player: Player, toPlayspaceRecord playspaceRecord: CKRecord, completion: @escaping (_ success: Bool) -> Void = { _ in }) {
        var player = player
        player.playspaces.append(CKReference(record: playspaceRecord, action: .none))
        PlayerController.shared.updatePlayer(player) { (success) in
            if success {
                PlayerController.shared.fetchCurrentPlayer(completion: { (success) in
                    if success {
                        completion(true)
                    }
                })
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
    
    func removeCurrentPlayerFrom(_ playspace: Playspace, completion: @escaping (_ success: Bool) -> Void = { _ in }) {
        guard var currentPlayer = PlayerController.shared.currentPlayer,
            let index = currentPlayer.playspaces.index(of: CKReference(recordID: playspace.recordID, action: .none)) else { completion(false); return }
        
        currentPlayer.playspaces.remove(at: index)
        CloudKitManager.shared.updateRecords([currentPlayer.CKRepresentation], perRecordCompletion: nil) { (_, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
                return
            }

            let tempURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(currentPlayer.recordID.recordName + ".dat")
            try? FileManager.default.removeItem(at: tempURL)
            
            GameController.shared.fetchGamesFor(playspace) { (games, success) in
                if success {
                    guard let games = games else { completion(false); return }
                    var updatedGameRecords = [CKRecord]()
                    for game in games {
                        guard var players = game.object(forKey: Game.playersKey) as? [CKReference],
                            let index = players.index(of: CKReference(recordID: currentPlayer.recordID, action: .none)) else { continue }
                        players.remove(at: index)
                        game.setObject(players as CKRecordValue, forKey: Game.playersKey)
                        updatedGameRecords.append(game)
                    }
                    
                    CloudKitManager.shared.updateRecordsIfServerRecordChanged(updatedGameRecords, perRecordCompletion: { (_, error) in
                        if let error = error as? CKError,
                            error.code == CKError.Code.serverRecordChanged,
                            let game = error.serverRecord {
                            
                            guard var players = game.object(forKey: Game.playersKey) as? [CKReference],
                                let index = players.index(of: CKReference(recordID: currentPlayer.recordID, action: .none)) else { return }
                            players.remove(at: index)
                            game.setObject(players as CKRecordValue, forKey: Game.playersKey)
                            CloudKitManager.shared.updateRecordsIfServerRecordChanged([game], perRecordCompletion: { (_, error) in
                                if let error = error {
                                    print(error.localizedDescription)
                                    completion(false)
                                    return
                                }
                            }, completion: { (_, error) in
                                if let error = error {
                                    print(error.localizedDescription)
                                    completion(false)
                                    return
                                }
                                
                                PlayerController.shared.fetchCurrentPlayer(completion: { (success) in
                                    if success {
                                        completion(true)
                                    }
                                })
                            })
                        }
                    }, completion: { (_, error) in
                        if let error = error {
                            print(error.localizedDescription)
                            completion(false)
                            return
                        }
                        
                        PlayerController.shared.fetchCurrentPlayer(completion: { (success) in
                            if success {
                                completion(true)
                            }
                        })
                    })
                    
//                    CloudKitManager.shared.updateRecords(updatedGameRecords, perRecordCompletion: nil, completion: { (_, error) in
//                        if let error = error {
//                            print(error.localizedDescription)
//                            completion(false)
//                            return
//                        }
//
//                        PlayerController.shared.fetchCurrentPlayer(completion: { (success) in
//                            if success {
//                                completion(true)
//                            }
//                        })
//                    })
                }
            }
        }
    }
    
}
