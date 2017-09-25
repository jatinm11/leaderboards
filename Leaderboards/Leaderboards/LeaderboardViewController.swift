//
//  LeaderboardViewController.swift
//  Leaderboards
//
//  Created by Jatin Menghani on 19/09/17.
//  Copyright © 2017 Jatin Menghani. All rights reserved.
//

import UIKit
import CloudKit

class LeaderboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var leaderboardTableView: UITableView!
    
    var playerStatsArrayOfDictionaries = [[String: Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        leaderboardTableView.delegate = self
        leaderboardTableView.dataSource = self
        
        
        GameController.shared.fetchAllPlayersForCurrentGame { (success) in
            if success {
                DispatchQueue.main.async {
                    self.createPlayerStatsDictionaries()
                }
                MatchController.shared.fetchMathesForCurrentGame(completion: { (success) in
                    if success {
                        DispatchQueue.main.async {
                            self.updatePlayerStatsDictionaries()
                        }
                    }
                })
            }
        }
        
        
        
    }
    
    func createPlayerStatsDictionaries() {
        for player in GameController.shared.playersBelongingToCurrentGame {
            self.playerStatsArrayOfDictionaries.append(["player": player, player.recordID.recordName: player.recordID, "played": 0, "wins": 0, "losses": 0, "winPercentage": 0.0])
        }
    }
    
    func updatePlayerStatsDictionaries() {
        let matchesInCurrentGame = MatchController.shared.matchesInCurrentGame
        for match in matchesInCurrentGame {
            for (index, playerStatsDictionary) in playerStatsArrayOfDictionaries.enumerated() {
                
                if let winner = playerStatsDictionary["player"] as? Player,
                    winner.recordID == match.winner.recordID,
                    let playedForWinnerDictionary = playerStatsDictionary["played"] as? Int,
                    let winsForWinnerDictionary = playerStatsDictionary["wins"] as? Int {
                    var winnerDictionary = playerStatsDictionary
                    winnerDictionary["played"] = playedForWinnerDictionary + 1
                    winnerDictionary["wins"] = winsForWinnerDictionary + 1
                    winnerDictionary["winPercentage"] = Double((winsForWinnerDictionary + 1)) / Double((playedForWinnerDictionary + 1))
                    playerStatsArrayOfDictionaries[index] = winnerDictionary
                }
                
                if let loser = playerStatsDictionary["player"] as? Player,
                    loser.recordID == match.loser.recordID,
                    let playedForLoserDictionary = playerStatsDictionary["played"] as? Int,
                    let winsForLoserDictionary = playerStatsDictionary["wins"] as? Int,
                    let lossesForLoserDictionary = playerStatsDictionary["losses"] as? Int {
                    var loserDictionary = playerStatsDictionary
                    loserDictionary["played"] = playedForLoserDictionary + 1
                    loserDictionary["losses"] = lossesForLoserDictionary + 1
                    loserDictionary["winPercentage"] = Double(winsForLoserDictionary) / Double((playedForLoserDictionary + 1))
                    playerStatsArrayOfDictionaries[index] = loserDictionary
                }
            }
        }
        sortPlayersBy(.wins)
        leaderboardTableView.reloadData()
    }
    
    func sortPlayersBy(_ column: Column) {
        playerStatsArrayOfDictionaries.sort { (dictionary1, dictionary2) -> Bool in
            if let dictionary1Wins = dictionary1["wins"] as? Int,
                let dictionary2Wins = dictionary2["wins"] as? Int,
                let dictionary1WinPercentage = dictionary1["winPercentage"] as? Double,
                let dictionary2WinPercentage = dictionary2["winPercentage"] as? Double,
                let dictionary1Played = dictionary1["played"] as? Int,
                let dictionary2Played = dictionary2["played"] as? Int {
                if column == .wins {
                    if dictionary1Wins > dictionary2Wins {
                        return true
                    } else if dictionary1Wins == dictionary2Wins {
                        return dictionary1Played > dictionary2Played
                    }
                } else {
                    if dictionary1WinPercentage > dictionary2WinPercentage {
                        return true
                    } else if dictionary1WinPercentage == dictionary2WinPercentage {
                        return dictionary1Played > dictionary2Played
                    }
                }
            }
            return false
        }
    }
    
    // MARK:- Table View Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playerStatsArrayOfDictionaries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "leaderboardCell", for: indexPath) as! LeaderboardTableViewCell
        cell.updateViewsWith(playerDictionary: playerStatsArrayOfDictionaries[indexPath.row])
        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}


// MARK: - Column Enum

enum Column: String {
    case wins
    case winPercentage
}
