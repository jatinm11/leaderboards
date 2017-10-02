//
//  CurrentPlayerProfileViewController.swift
//  Leaderboards
//
//  Created by Jatin Menghani on 25/09/17.
//  Copyright © 2017 Jatin Menghani. All rights reserved.
//

import UIKit

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
    var matches = [[Match]]()
    var playerStatsArrayOfDictionaries = [[String: Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                    self.games = games
                    self.createPlayerStatsDictionaries()
                    GameController.shared.fetchPlayspacesForGames(games, completion: { (playspaces, success) in
                        if success {
                            if let playspaces = playspaces {
                                self.playspaces = playspaces
                                for game in self.games {
                                    MatchController.shared.fetchMatchesForGame(game, andPlayer: currentPlayer, completion: { (matches, success) in
                                        if success {
                                            guard let matches = matches else { return }
                                            self.matches.append(matches)
                                            self.processMatches()
                                            DispatchQueue.main.async {
                                                self.tableView.reloadData()
                                            }
                                        }
                                    })
                                }
                            }
                        }
                    })
                }
            }
        }
    }
    
    func createPlayerStatsDictionaries() {
        for _ in 0..<games.count {
            playerStatsArrayOfDictionaries.append(["played": 0, "wins": 0, "losses": 0, "winPercentage": 0.0, "pointsFor": 0, "pointsAgainst": 0])
        }
    }
    
    func processMatches() {
        guard let currentPlayer = PlayerController.shared.currentPlayer else { return }
        
        for (index, gameMatches) in matches.enumerated() {
            for match in gameMatches {
                guard let played = playerStatsArrayOfDictionaries[index]["played"] as? Int,
                    let wins = playerStatsArrayOfDictionaries[index]["wins"] as? Int,
                    let losses = playerStatsArrayOfDictionaries[index]["losses"] as? Int,
                    let pointsFor = playerStatsArrayOfDictionaries[index]["pointsFor"] as? Int,
                    let pointsAgainst = playerStatsArrayOfDictionaries[index]["pointsAgainst"] as? Int else { return }
                
                if match.winner.recordID == currentPlayer.recordID {
                    playerStatsArrayOfDictionaries[index]["played"] = played + 1
                    playerStatsArrayOfDictionaries[index]["wins"] = wins + 1
                    playerStatsArrayOfDictionaries[index]["winPercentage"] = Double(played + 1) / Double(wins + 1)
                    playerStatsArrayOfDictionaries[index]["pointsFor"] = pointsFor + match.winnerScore
                    playerStatsArrayOfDictionaries[index]["pointsAgainst"] = pointsAgainst + match.loserScore
                } else {
                    playerStatsArrayOfDictionaries[index]["played"] = played + 1
                    playerStatsArrayOfDictionaries[index]["losses"] = losses + 1
                    playerStatsArrayOfDictionaries[index]["winPercentage"] = Double(wins) / Double(played + 1)
                    playerStatsArrayOfDictionaries[index]["pointsFor"] = pointsFor + match.loserScore
                    playerStatsArrayOfDictionaries[index]["pointsAgainst"] = pointsAgainst + match.winnerScore
                }
            }
        }
    }

}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension CurrentPlayerProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return games.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(games[section].name) in \(playspaces[section].name)"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "gameStatsCell", for: indexPath) as? GameStatsTableViewCell else { return GameStatsTableViewCell() }
        cell.updateViewsWith(playerStatsArrayOfDictionaries[indexPath.section])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 146
    }
    
}
