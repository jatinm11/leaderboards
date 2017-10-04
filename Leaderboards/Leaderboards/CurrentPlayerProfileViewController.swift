//
//  CurrentPlayerProfileViewController.swift
//  Leaderboards
//
//  Created by Jatin Menghani on 25/09/17.
//  Copyright © 2017 Jatin Menghani. All rights reserved.
//

import UIKit
import CloudKit

class CurrentPlayerProfileViewController: UIViewController {
    
    @IBOutlet weak var playerImageView: UIImageView!
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    
    @IBAction func backBarButtonItemTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    var games = [Game]()
    var playspaces = [Playspace]()
    var uniquePlayspaces = [Playspace]()
    var matches = [[Match]]()
    var playerStatsArrayOfDictionaries = [[[String: Any]]]()
    
    let operationQueue = OperationQueue()
    let colorProvider = BackgroundColorProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let randomColor = colorProvider.randomColor()
        self.view.backgroundColor = randomColor
        tableView.backgroundColor = randomColor
        tableView.tableFooterView = UIView()
        playerImageView.layer.cornerRadius = playerImageView.frame.width / 2
        playerImageView.clipsToBounds = true
        playerImageView.layer.borderWidth = 3.0
        playerImageView.layer.borderColor = UIColor.white.cgColor
        
        tableView.delegate = self
        tableView.dataSource = self
        
        playerNameLabel.text = PlayerController.shared.currentPlayer?.username
        playerImageView.image = PlayerController.shared.currentPlayer?.photo
        
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        
        guard let currentPlayer = PlayerController.shared.currentPlayer else { return }
        GameController.shared.fetchAllGamesForCurrentPlayer { (games, success) in
            if success {
                if let games = games {
                    for _ in 0..<games.count {
                        self.matches.append([])
                    }
                    self.games = games
                    GameController.shared.fetchPlayspacesForGames(games, completion: { (playspaces, success) in
                        if success {
                            if let playspaces = playspaces {
                                self.playspaces = playspaces
                                self.processPlayspaces()
                                self.createPlayerStatsDictionaries()
                                
                                let group = DispatchGroup()
                                for (index, game) in self.games.enumerated() {
                                    group.enter()
                                    
                                    MatchController.shared.fetchMatchesForGame(game, andPlayer: currentPlayer, completion: { (matches, success) in
                                        if success {
                                            guard let matches = matches else { return }
                                            self.matches[index] = matches
                                            group.leave()
                                        }
                                    })
                                    
                                    
                                }
                                
                                group.notify(queue: DispatchQueue.main, execute: {
                                    self.processMatches()
                                    self.tableView.reloadData()
                                })
                                
                                
                            }
                        }
                    })
                }
            }
        }
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    func createPlayerStatsDictionaries() {
        for (index, playspace) in uniquePlayspaces.enumerated() {
            playerStatsArrayOfDictionaries.append([])
            for game in games {
                if game.playspace.recordID == playspace.recordID {
                    playerStatsArrayOfDictionaries[index].append(["game": game, "played": 0, "wins": 0, "losses": 0, "winPercentage": 0.0, "pointsFor": 0, "pointsAgainst": 0])
                }
            }
        }
    }
    
    func processMatches() {
        guard let currentPlayer = PlayerController.shared.currentPlayer else { return }
        
        for (index, playspace) in uniquePlayspaces.enumerated() {
            for (gameIndex, game) in games.enumerated() {
                if game.playspace.recordID == playspace.recordID {
                    for (gameStatsIndex, gameStats) in playerStatsArrayOfDictionaries[index].enumerated() {
                        guard let gameFromDict = gameStats["game"] as? Game else { return }
                        if game.recordID == gameFromDict.recordID {
                            for match in matches[gameIndex] {
                                guard let played = playerStatsArrayOfDictionaries[index][gameStatsIndex]["played"] as? Int,
                                    let wins = playerStatsArrayOfDictionaries[index][gameStatsIndex]["wins"] as? Int,
                                    let losses = playerStatsArrayOfDictionaries[index][gameStatsIndex]["losses"] as? Int,
                                    let pointsFor = playerStatsArrayOfDictionaries[index][gameStatsIndex]["pointsFor"] as? Int,
                                    let pointsAgainst = playerStatsArrayOfDictionaries[index][gameStatsIndex]["pointsAgainst"] as? Int else { return }
                                
                                if match.winner.recordID == currentPlayer.recordID {
                                    playerStatsArrayOfDictionaries[index][gameStatsIndex]["played"] = played + 1
                                    playerStatsArrayOfDictionaries[index][gameStatsIndex]["wins"] = wins + 1
                                    playerStatsArrayOfDictionaries[index][gameStatsIndex]["winPercentage"] = Double(played + 1) / Double(wins + 1)
                                    playerStatsArrayOfDictionaries[index][gameStatsIndex]["pointsFor"] = pointsFor + match.winnerScore
                                    playerStatsArrayOfDictionaries[index][gameStatsIndex]["pointsAgainst"] = pointsAgainst + match.loserScore
                                } else {
                                    playerStatsArrayOfDictionaries[index][gameStatsIndex]["played"] = played + 1
                                    playerStatsArrayOfDictionaries[index][gameStatsIndex]["losses"] = losses + 1
                                    playerStatsArrayOfDictionaries[index][gameStatsIndex]["winPercentage"] = Double(wins) / Double(played + 1)
                                    playerStatsArrayOfDictionaries[index][gameStatsIndex]["pointsFor"] = pointsFor + match.loserScore
                                    playerStatsArrayOfDictionaries[index][gameStatsIndex]["pointsAgainst"] = pointsAgainst + match.winnerScore
                                }
                            }
                        }
                    }
                }
            }
        }
        
        //        for (index, gameMatches) in matches.enumerated() {
        //            for match in gameMatches {
        //                guard let played = playerStatsArrayOfDictionaries[index]["played"] as? Int,
        //                    let wins = playerStatsArrayOfDictionaries[index]["wins"] as? Int,
        //                    let losses = playerStatsArrayOfDictionaries[index]["losses"] as? Int,
        //                    let pointsFor = playerStatsArrayOfDictionaries[index]["pointsFor"] as? Int,
        //                    let pointsAgainst = playerStatsArrayOfDictionaries[index]["pointsAgainst"] as? Int else { return }
        //
        //                if match.winner.recordID == currentPlayer.recordID {
        //                    playerStatsArrayOfDictionaries[index]["played"] = played + 1
        //                    playerStatsArrayOfDictionaries[index]["wins"] = wins + 1
        //                    playerStatsArrayOfDictionaries[index]["winPercentage"] = Double(played + 1) / Double(wins + 1)
        //                    playerStatsArrayOfDictionaries[index]["pointsFor"] = pointsFor + match.winnerScore
        //                    playerStatsArrayOfDictionaries[index]["pointsAgainst"] = pointsAgainst + match.loserScore
        //                } else {
        //                    playerStatsArrayOfDictionaries[index]["played"] = played + 1
        //                    playerStatsArrayOfDictionaries[index]["losses"] = losses + 1
        //                    playerStatsArrayOfDictionaries[index]["winPercentage"] = Double(wins) / Double(played + 1)
        //                    playerStatsArrayOfDictionaries[index]["pointsFor"] = pointsFor + match.loserScore
        //                    playerStatsArrayOfDictionaries[index]["pointsAgainst"] = pointsAgainst + match.winnerScore
        //                }
        //            }
        //        }
    }
    
    func processPlayspaces() {
        var uniquePlayspaces = [Playspace]()
        for playspace in playspaces {
            if !uniquePlayspaces.contains(playspace) {
                uniquePlayspaces.append(playspace)
            }
        }
        self.uniquePlayspaces = uniquePlayspaces
    }
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension CurrentPlayerProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return uniquePlayspaces.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(uniquePlayspaces[section].name)"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playerStatsArrayOfDictionaries[section].count + 1
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerTitle = view as? UITableViewHeaderFooterView {
            headerTitle.textLabel?.textColor = UIColor.white
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "labelCell", for: indexPath)
            return cell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "gameStatsCell", for: indexPath) as? GameStatsTableViewCell else { return GameStatsTableViewCell() }
        cell.updateViewsWith(playerStatsArrayOfDictionaries[indexPath.section][indexPath.row - 1])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 40
        }
        return 50
    }
    
}
