//
//  PlayerProfileViewController.swift
//  Leaderboards
//
//  Created by Mithun Reddy on 10/4/17.
//  Copyright © 2017 Jatin Menghani. All rights reserved.
//

import UIKit

class PlayerProfileViewController: UIViewController {
    
    @IBOutlet weak var playerImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var matches: [Match]?
    var opponents: [Player]?
    var player: Player?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        playerImage.image = player?.photo
        usernameLabel.text = player?.username
        guard let currentGame = GameController.shared.currentGame,
            let player = player else { return }
        MatchController.shared.fetchMatchesForGame(currentGame, andPlayer: player) { (matches, success) in
            if success {
                self.matches = matches
                guard let matches = matches else { return }
                MatchController.shared.fetchOpponentsForMatches(matches, player: player, completion: { (opponents, success) in
                    if success {
                        DispatchQueue.main.async {
                            self.opponents = opponents
                            self.tableView.reloadData()
                        }
                    }
                })
            }
        }
    }
    
}

extension PlayerProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matches?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "matchCell", for: indexPath) as? PlayerProfileMatchHistoryTableViewCell else { return PlayerProfileMatchHistoryTableViewCell() }
        cell.updateViewsWith(opponent: opponents?[indexPath.row], match: matches?[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
}
