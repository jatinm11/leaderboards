//
//  LeaderboardViewController.swift
//  Leaderboards
//
//  Created by Jatin Menghani on 19/09/17.
//  Copyright © 2017 Jatin Menghani. All rights reserved.
//

import UIKit

class LeaderboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var leaderboardTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        leaderboardTableView.delegate = self
        leaderboardTableView.dataSource = self
        
   
                MatchController.shared.fetchMathesForCurrentGame(completion: { (success) in
                    if success {
                        let matchesInCurrentGame = MatchController.shared.matchesInCurrentGame
                        for match in matchesInCurrentGame {
                            PlayerController.shared.fetchPlayer(match.winner.recordID, completion: { (player, success) in
                                if success {
                                    
                                }
                            })
                        }
                    }
                })
        
        
    }
    
    func createPlayerStatsDictionaries() {
        var arrayOfDictionaries = [[String:[String:Int]]]()
        for player in GameController.shared.playersBelongingToCurrentGame {
            var played: Int = 0
            var dictionary = [String:[String:Int]]()
            dictionary["\(player.recordID)"] = ["played":0, "wins": 0, "losses":0, "winPercentage": 0]
        }
    }
    
    // MARK:- Table View Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GameController.shared.playersBelongingToCurrentGame.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "leaderboardCell", for: indexPath) as! LeaderboardTableViewCell
        let player = GameController.shared.playersBelongingToCurrentGame[indexPath.row]
//        let playerStats = MatchController.shared.dictionaries["\(player.recordID)"]
        cell.player = player
        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}
