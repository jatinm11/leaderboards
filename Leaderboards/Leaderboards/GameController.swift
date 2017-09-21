//
//  GameController.swift
//  Leaderboards
//
//  Created by Mithun Reddy on 9/20/17.
//  Copyright © 2017 Jatin Menghani. All rights reserved.
//

import Foundation
import CloudKit

class GameController {
    
    static let shared = GameController()
    
    var games = [Game]()
    
    var gamesNotBelongingToCurrentPlayer = [Game]()
    var gamesBelongingToCurrentPlayer = [Game]()
    var playersBelongingToCurrentGame = [Player]()
    
    func createGameWith(name: String, completion: @escaping (_ success: Bool) -> Void = { _ in }) {
        guard let currentPlayerRecord = PlayerController.shared.currentPlayer?.CKRepresentation,
            let currentPlayspaceRecord = PlayspaceController.shared.currentPlayspace?.CKRepresentation else { completion(false); return }
        
        let game = Game(recordID: CKRecordID(recordName: UUID().uuidString), name: name, playspace: CKReference(record: currentPlayspaceRecord, action: .none), players: [CKReference(record: currentPlayerRecord, action: .none)])
        
        CloudKitManager.shared.saveRecord(game.CKRepresentation) { (record, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
                return
            }
            
            completion(true)
        }
    }
    
    func fetchGamesForCurrentPlayspace(completion: @escaping (_ success: Bool) -> Void = { _ in }) {
        guard let currentPlayspace = PlayspaceController.shared.currentPlayspace else { completion(false); return }
        
        let predicate = NSPredicate(format: "playspace == %@", currentPlayspace.recordID)
        
        CloudKitManager.shared.fetchRecordsWithType(Game.recordType, predicate: predicate, recordFetchedBlock: nil) { (records, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
                return
            }
            
            guard let gamesRecords = records else { completion(false); return }
            let games = gamesRecords.flatMap { Game(record: $0) }
            self.games = games
            self.sortGamesForCurrentPlayer()
            completion(true)
        }
    }
    
    
    func sortGamesForCurrentPlayer() {
        var gamesNotBelongingToCurrentPlayer = [Game]()
        let gamesBelongingToCurrentPlayer = games.filter { (game) -> Bool in
            for player in game.players {
                if player.recordID == PlayerController.shared.currentPlayer?.recordID {
                    return true
                }
            }
            gamesNotBelongingToCurrentPlayer.append(game)
            return false
        }
        self.gamesNotBelongingToCurrentPlayer = gamesNotBelongingToCurrentPlayer
        self.gamesBelongingToCurrentPlayer = gamesBelongingToCurrentPlayer
    }
    
    func addCurrentPlayerToGame(_ game: Game, completion: @escaping (_ success: Bool) -> Void = { _ in }) {
        var game = game
        guard let currentPlayer = PlayerController.shared.currentPlayer else { completion(false); return }
        game.players.append(CKReference(record: currentPlayer.CKRepresentation, action: .none))
        CloudKitManager.shared.updateRecords([game.CKRepresentation], perRecordCompletion: nil) { (_, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    
    func fetchPlayersForCurrentGame(completion: @escaping (_ success: Bool) -> Void = { _ in }) {
        var playersBelongingToCurrentGame = [Player]()
        let players = CKReference(recordID: <#T##CKRecordID#>, action: <#T##CKReferenceAction#>)
    }
    
}
