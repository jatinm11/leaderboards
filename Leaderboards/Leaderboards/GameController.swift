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
    
    var currentGame: Game?
    
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
            
            self.gamesBelongingToCurrentPlayer.append(game)
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
            self.sortGamesForCurrentPlayer(completion: { (success) in
                if success {
                    completion(true)
                } else {
                    completion(false)
                }
            })
        }
    }
    
    
    func sortGamesForCurrentPlayer(completion: @escaping (_ success: Bool) -> Void = { _ in }) {
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
        completion(true)
    }
    
    func addCurrentPlayerToGame(_ game: Game, completion: @escaping (_ game: Game?, _ success: Bool) -> Void = { _, _ in }) {
        var game = game
        guard let currentPlayer = PlayerController.shared.currentPlayer else { completion(nil, false); return }
        game.players.append(CKReference(record: currentPlayer.CKRepresentation, action: .none))
        CloudKitManager.shared.updateRecords([game.CKRepresentation], perRecordCompletion: nil) { (records, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(nil, false)
                return
            }
            guard let gameRecord = records?.first,
                let game = Game(record: gameRecord) else { completion(nil, false); return }
            completion(game, true)
        }
    }
    
    func addCurrentPlayerToGame2(_ game: Game, completion: @escaping (_ game: Game?, _ success: Bool) -> Void = { _, _ in }) {
        guard let currentPlayer = PlayerController.shared.currentPlayer else { completion(nil, false); return }
        
        CloudKitManager.shared.fetchRecord(withID: game.recordID) { (game, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(nil, false)
                return
            }
            
            guard let game = game,
                var players = game.value(forKey: Game.playersKey) as? [CKReference] else { completion(nil, false); return }
            players.append(CKReference(recordID: currentPlayer.recordID, action: .none))
            game.setValue(players, forKey: Game.playersKey)
            
            CloudKitManager.shared.updateRecordsIfServerRecordChanged([game], perRecordCompletion: { (_, error) in
                if let error = error as? CKError,
                    error.code == CKError.Code.serverRecordChanged,
                    let gameServerRecord = error.serverRecord {
                    guard var players = gameServerRecord.value(forKey: Game.playersKey) as? [CKReference] else { completion(nil, false); return }
                    
                    players.append(CKReference(recordID: currentPlayer.recordID, action: .none))
                    gameServerRecord.setValue(players as CKRecordValue, forKey: Game.playersKey)
                    
                    CloudKitManager.shared.updateRecordsIfServerRecordChanged([gameServerRecord], perRecordCompletion: { (_, error) in
                        if let error = error {
                            print(error.localizedDescription)
                            completion(nil, false)
                            return
                        }
                    }, completion: { (_, error) in
                        if let error = error {
                            print(error.localizedDescription)
                            completion(nil, false)
                            return
                        }
                        
                        completion(Game(record: gameServerRecord), true)
                    })
                }
            }, completion: { (_, error) in
                if let error = error {
                    print(error.localizedDescription)
                    completion(nil, false)
                    return
                }
                
                completion(Game(record: game), true)
            })
            
        }
    }
    
    func fetchOpponentsForCurrentGame(completion: @escaping (_ success: Bool) -> Void = { _ in }) {
        guard let currentGame = currentGame else { completion(false); return }
        
        let opponentsRecordIDs = currentGame.players.flatMap { $0.recordID }.filter {
            if $0 == PlayerController.shared.currentPlayer?.recordID {
                return false
            }
            return true
        }
        
        CloudKitManager.shared.fetchRecords(withIDs: opponentsRecordIDs) { (playerRecordsDictionary, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
                return
            }
            
            guard let playerRecordsDictionary = playerRecordsDictionary else { completion(false); return }
            var opponentsRecords = [CKRecord]()
            for playerRecord in playerRecordsDictionary.values {
                opponentsRecords.append(playerRecord)
            }
            
            let opponents = opponentsRecords.flatMap { Player(record: $0) }
            PlayerController.shared.opponents = opponents
            completion(true)
        }
    }
    
    func fetchAllPlayersForCurrentGame(completion: @escaping (_ success: Bool) -> Void = { _ in }) {
        guard let currentGame = currentGame else { completion(false); return }
        
        let playerRecordIDs = currentGame.players.flatMap { $0.recordID }
        
        CloudKitManager.shared.fetchRecords(withIDs: playerRecordIDs) { (playerRecordsDictionary, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
                return
            }
            
            guard let playerRecordsDictionary = playerRecordsDictionary else { completion(false); return }
            var playersRecords = [CKRecord]()
            for playerRecord in playerRecordsDictionary.values {
                playersRecords.append(playerRecord)
            }
            
            let players = playersRecords.flatMap { Player(record: $0) }
            self.playersBelongingToCurrentGame = players
            completion(true)
        }
    }
    
    func fetchAllGamesForCurrentPlayer(completion: @escaping (_ games: [Game]?,_ success: Bool) -> Void = { _, _  in }) {
        guard let currentPlayer = PlayerController.shared.currentPlayer else { completion(nil, false); return }
        
        let currentPlayerIsInGamePredicate = NSPredicate(format: "players CONTAINS %@", currentPlayer.recordID)
        
        CloudKitManager.shared.fetchRecordsWithType(Game.recordType, predicate: currentPlayerIsInGamePredicate, recordFetchedBlock: nil) { (records, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(nil, false)
                return
            }
            
            guard let gameRecords = records else { completion(nil, false); return }
            let games = gameRecords.flatMap { Game(record: $0) }
            completion(games, true)
        }
    }
    
    func fetchPlayspacesForGames(_ games: [Game], completion: @escaping (_ playspaces: [Playspace]?, _ success: Bool) -> Void = { _, _  in }) {
        let playspaceRecordIDs = games.flatMap { $0.playspace.recordID }
        
        CloudKitManager.shared.fetchRecords(withIDs: playspaceRecordIDs) { (playspacesDictionary, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(nil, false)
                return
            }
            
            guard let playspacesDictonary = playspacesDictionary else { completion(nil, false); return }
            
            var playspaceRecords = [CKRecord]()
            for playspaceRecordID in playspaceRecordIDs {
                let playspaceRecord = playspacesDictonary[playspaceRecordID]
                if let playspaceRecord = playspaceRecord {
                    playspaceRecords.append(playspaceRecord)
                }
            }
            
            let playspaces = playspaceRecords.flatMap { Playspace(record: $0) }
            completion(playspaces, true)
        }
    }
    
    func removeCurrentPlayerFrom(_ game: Game, completion: @escaping (_ game: Game?, _ success: Bool) -> Void = { _, _ in }) {
        var game = game
        guard let currentPlayer = PlayerController.shared.currentPlayer,
            let index = game.players.index(of: CKReference(recordID: currentPlayer.recordID, action: .none)) else { completion(nil, false); return }
        
        game.players.remove(at: index)
        
        CloudKitManager.shared.updateRecords([game.CKRepresentation], perRecordCompletion: nil) { (records, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(nil, false)
                return
            }
            
            guard let gameRecord = records?.first,
                let game = Game(record: gameRecord) else { completion(nil, false); return }
            
            completion(game, true)
        }
    }
    
    func removeCurrentPlayerFrom2(_ game: Game, completion: @escaping (_ game: Game?, _ success: Bool) -> Void = { _, _ in }) {
        
        guard let currentPlayer = PlayerController.shared.currentPlayer else { completion(nil, false); return }
        
        CloudKitManager.shared.fetchRecord(withID: game.recordID) { (game, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(nil, false)
                return
            }
            
            guard let game = game,
                var players = game.value(forKey: Game.playersKey) as? [CKReference],
                let index = players.index(of: CKReference(recordID: currentPlayer.recordID, action: .none)) else { completion(nil, false); return }
            
            players.remove(at: index)
            game.setObject(players as CKRecordValue, forKey: Game.playersKey)
            
            CloudKitManager.shared.updateRecordsIfServerRecordChanged([game], perRecordCompletion: { (_, error) in
                if let error = error as? CKError,
                    error.code == CKError.Code.serverRecordChanged,
                    let gameServerRecord = error.serverRecord {
                    guard var players = gameServerRecord.value(forKey: Game.playersKey) as? [CKReference],
                        let index = players.index(of: CKReference(recordID: currentPlayer.recordID, action: .none)) else { completion(nil, false); return }
                    
                    players.remove(at: index)
                    gameServerRecord.setValue(players as CKRecordValue, forKey: Game.playersKey)
                    
                    CloudKitManager.shared.updateRecordsIfServerRecordChanged([gameServerRecord], perRecordCompletion: { (_, error) in
                        if let error = error {
                            print(error.localizedDescription)
                            completion(nil, false)
                            return
                        }
                    }, completion: { (_, error) in
                        if let error = error {
                            print(error.localizedDescription)
                            completion(nil, false)
                            return
                        }
                        
                        completion(Game(record: gameServerRecord), true)
                    })
                    
                }
            }, completion: { (_, error) in
                if let error = error {
                    print(error.localizedDescription)
                    completion(nil, false)
                    return
                }
                
                completion(Game(record: game), true)
            })
            
        }
    
    }
    
    func fetchGamesFor(_ playspace: Playspace, completion: @escaping (_ games: [CKRecord]?, _ success: Bool) -> Void = { _, _ in }) {
        
        let predicate = NSPredicate(format: "playspace == %@", playspace.recordID)
        
        CloudKitManager.shared.fetchRecordsWithType(Game.recordType, predicate: predicate, recordFetchedBlock: nil) { (records, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(nil, false)
                return
            }
            
            guard let gamesRecords = records else { completion(nil, false); return }
            
            completion(gamesRecords, true)
        }
    }
    
}
