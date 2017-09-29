//
//  PlayerViewController.swift
//  Leaderboards
//
//  Created by Jatin Menghani on 19/09/17.
//  Copyright © 2017 Jatin Menghani. All rights reserved.
//

import UIKit

class PlayerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let colorProvider = BackgroundColorProvider()
    @IBOutlet var playerTableView: UITableView!
    @IBOutlet weak var leaderboardsButton: UIButton!
    @IBOutlet weak var leaderboardTableView: UITableView!
    @IBOutlet weak var playersView: UIView!
    @IBOutlet weak var leaderboardsView: UIView!
    @IBOutlet weak var leaderboardsButtonViewContainer: UIView!
    
    @IBAction func swipeGestureSwiped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    var playerStatsArrayOfDictionaries = [[String: Any]]()
//    var playersViewAnimated = false
//    var leaderboardsViewAnimated = false
//    var leaderboardsViewShouldAnimate = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerTableView.delegate = self
        playerTableView.dataSource = self
        leaderboardTableView.delegate = self
        leaderboardTableView.dataSource = self
        playerTableView.tag = 0
        leaderboardTableView.tag = 1
        leaderboardsView.alpha = 0
        
        leaderboardsButtonViewContainer.layer.cornerRadius = 5
        leaderboardsButtonViewContainer.clipsToBounds = true
        randomColor()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    @IBAction func leaderboardsButtonTapped(_ sender: Any) {
        if leaderboardsView.alpha == 0 {
            leaderboardsView.alpha = 1
            playersView.alpha = 0
            leaderboardsButton.setTitle("Players", for: .normal)
            //leaderboardsViewShouldAnimate = true
            leaderboardTableView.reloadData()
            randomColor()
        } else {
            leaderboardsView.alpha = 0
            playersView.alpha = 1
            leaderboardsButton.setTitle("Leaderboards", for: .normal)
            randomColor()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        playerStatsArrayOfDictionaries = []
        
        GameController.shared.fetchAllPlayersForCurrentGame { (success) in
            if success {
                DispatchQueue.main.async {
                    self.playerTableView.reloadData()
                    self.createPlayerStatsDictionaries()
                }
                MatchController.shared.fetchMatchesForCurrentGame(completion: { (success) in
                    if success {
                        DispatchQueue.main.async {
                            self.updatePlayerStatsDictionaries()
                        }
                    }
                })
            }
        }
    }
    
    func randomColor() {
        let randomColor = colorProvider.randomColor()
        view.backgroundColor = randomColor
        playersView.backgroundColor = randomColor
        leaderboardsView.backgroundColor = randomColor
        self.leaderboardsButton.tintColor = randomColor
        self.playerTableView.backgroundColor = randomColor
        self.leaderboardTableView.backgroundColor = randomColor
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
    
    // MARK:- TableView data source.
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 0 {
            return GameController.shared.playersBelongingToCurrentGame.count
        }
        return playerStatsArrayOfDictionaries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "playerCell", for: indexPath) as! PlayerTableViewCell
            let player = GameController.shared.playersBelongingToCurrentGame[indexPath.row]
            cell.player = player
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "leaderboardCell", for: indexPath) as! LeaderboardTableViewCell
        cell.updateViewsWith(playerDictionary: playerStatsArrayOfDictionaries[indexPath.row])
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if tableView.tag == 0 && playersViewAnimated == false {
//            cell.alpha = 0
//            cell.backgroundColor = UIColor.clear
//            UIView.animate(withDuration: 1.0) {
//                cell.alpha = 1.0
//            }
//        }
//        if tableView.tag == 0 && playersViewAnimated == false  && indexPath.row == GameController.shared.playersBelongingToCurrentGame.count - 1{
//            playersViewAnimated = true
//        }
//
//        if tableView.tag == 1 && leaderboardsViewAnimated == false && leaderboardsViewShouldAnimate == true {
//            cell.alpha = 0
//            cell.backgroundColor = UIColor.clear
//            UIView.animate(withDuration: 1.0) {
//                cell.alpha = 1.0
//            }
//        }
//        if tableView.tag == 1 && leaderboardsViewAnimated == false && leaderboardsViewShouldAnimate == true && indexPath.row == playerStatsArrayOfDictionaries.count - 1{
//            leaderboardsViewAnimated = true
//            leaderboardsViewShouldAnimate = false
//        }
//    }
    
//    func animateTable() {
//        playerTableView.reloadData()
//        let cells = playerTableView.visibleCells
//
//        let tableViewHeight = playerTableView.bounds.size.height
//
//        for cell in cells {
//            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
//        }
//
//        var delayCounter = 0
//        for cell in cells {
//            UIView.animate(withDuration: 1.0, delay: Double(delayCounter) * 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
//                cell.transform = CGAffineTransform.identity
//                }, completion: nil)
//            delayCounter += 1
//        }
//    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}










