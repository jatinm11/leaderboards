//
//  CurrentPlayerMatchHistoryViewController.swift
//  Leaderboards
//
//  Created by Mithun Reddy on 10/4/17.
//  Copyright © 2017 Jatin Menghani. All rights reserved.
//

import UIKit

class CurrentPlayerMatchHistoryViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var matches: [Match]?
    var opponents: [Player]?
    var games: [Game]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        MatchController.shared.fetchMatchesForCurrentPlayer { (matches, success) in
            if success {
                self.matches = matches
                guard let matches = matches,
                    let currentPlayer = PlayerController.shared.currentPlayer else { return }
                MatchController.shared.fetchOpponentsForMatches(matches, player: currentPlayer, completion: { (opponents, success) in
                    if success {
                        self.opponents = opponents
                        MatchController.shared.fetchGamesForMatches(matches, completion: { (games, success) in
                            if success {
                                DispatchQueue.main.async {
                                    self.games = games
                                    self.tableView.reloadData()
                                }
                            }
                        })
                    }
                })
            }
        }
    }
    
}

extension CurrentPlayerMatchHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matches?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "matchCell", for: indexPath) as? CurrentPlayerMatchHistoryTableViewCell else { return CurrentPlayerMatchHistoryTableViewCell() }
        cell.updateViewsWith(opponent: opponents?[indexPath.row], match: matches?[indexPath.row], game: games?[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
}
