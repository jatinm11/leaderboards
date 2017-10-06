//
//  LeaderboardsViewController.swift
//  Leaderboards
//
//  Created by Mithun Reddy on 10/3/17.
//  Copyright © 2017 Jatin Menghani. All rights reserved.
//

import UIKit

class LeaderboardsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var playerStatsArrayOfDictionaries = [[String: Any]]()
    let colorProvider = BackgroundColorProvider()
    var randomColor: UIColor?
    static let fetchAllPlayersComplete = Notification.Name(rawValue:"fetchAllPlayersComplete")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        randomColor = colorProvider.randomColor()
        view.backgroundColor = randomColor
        tableView.backgroundColor = randomColor
        
        let addMatchBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMatchBarButtonItemTapped))
        navigationItem.rightBarButtonItem = addMatchBarButtonItem
        
        GameController.shared.fetchAllPlayersForCurrentGame { (success) in
            if success {
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: LeaderboardsViewController.fetchAllPlayersComplete, object: nil)
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
        tableView.reloadData()
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
    
    @objc func addMatchBarButtonItemTapped() {
        let newMatchVC = UIStoryboard(name: "Match", bundle: nil).instantiateViewController(withIdentifier: "newMatchVC")
        present(newMatchVC, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPlayerDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let playerProfileVC = segue.destination as? PlayerProfileViewController
            playerProfileVC?.player = playerStatsArrayOfDictionaries[indexPath.row]["player"] as? Player
        }
    }
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension LeaderboardsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return playerStatsArrayOfDictionaries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "leaderboardsTitleCell", for: indexPath)
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "leaderboardsCell", for: indexPath) as? LeaderboardTableViewCell else { return LeaderboardTableViewCell() }
        cell.updateViewsWith(playerDictionary: playerStatsArrayOfDictionaries[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: tableView.sectionHeaderHeight))
            headerView.backgroundColor = randomColor
            
            let playerLabel = UILabel()
            playerLabel.text = "Player"
            playerLabel.textColor = .white
            playerLabel.font = UIFont(name: "Avenir Next", size: 20.0)
            
            let playedLabel = UILabel()
            playedLabel.text = "Played"
            playedLabel.textColor = .white
            playedLabel.font = UIFont(name: "Avenir Next", size: 20.0)
            
            let wonLabel = UILabel()
            wonLabel.text = "Won"
            wonLabel.textColor = .white
            wonLabel.font = UIFont(name: "Avenir Next", size: 20.0)
            
            let lossLabel = UILabel()
            lossLabel.text = "Loss"
            lossLabel.textColor = .white
            lossLabel.font = UIFont(name: "Avenir Next", size: 20.0)
            
            let winPerLabel = UILabel()
            winPerLabel.text = "Win %"
            winPerLabel.textColor = .white
            winPerLabel.font = UIFont(name: "Avenir Next", size: 20.0)
            
            let labelStackView = UIStackView(arrangedSubviews: [playerLabel, playedLabel, wonLabel, lossLabel, winPerLabel])
            labelStackView.axis = .horizontal
            labelStackView.alignment = .fill
            labelStackView.distribution = .equalSpacing
            labelStackView.spacing = 0
            labelStackView.contentMode = .scaleToFill
            labelStackView.autoresizesSubviews = true
            labelStackView.clearsContextBeforeDrawing = true
            headerView.addSubview(labelStackView)
            
            let views: [String: Any] = ["labelStackView": labelStackView, "headerView": headerView]
            let headerViewHorizontalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "|-(8)-[labelStackView]-(8)-|", options: [], metrics: nil, views: views)
            let headerViewVerticalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:|[labelStackView]|", options: [], metrics: nil, views: views)
            
            labelStackView.translatesAutoresizingMaskIntoConstraints = false
            
            headerView.addConstraints(headerViewHorizontalConstraint)
            headerView.addConstraints(headerViewVerticalConstraint)
            
            return headerView
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 44
        }
        return 87
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 28
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            navigationController?.topViewController?.title = GameController.shared.currentGame?.name
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            navigationController?.topViewController?.title = "Leaderboards"
        }
    }
    
}
