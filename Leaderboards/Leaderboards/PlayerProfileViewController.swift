//
//  PlayerProfileViewController.swift
//  Leaderboards
//
//  Created by Mithun Reddy on 10/4/17.
//  Copyright © 2017 Jatin Menghani. All rights reserved.
//

import UIKit

class PlayerProfileViewController: UIViewController {
    
    let colorProvider = BackgroundColorProvider()
    
    @IBOutlet weak var tableView: UITableView!
    
    var matches: [Match]?
    var opponents: [Player]?
    var player: Player?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = player?.username
        
        let randomColor = colorProvider.randomColor()
        self.view.backgroundColor = randomColor
        self.tableView.backgroundColor = randomColor
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
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
        guard let count = matches?.count else { return 0 }
        return count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "matchHistoryTitleCell", for: indexPath)
            return cell
        }
        if indexPath.row == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "lastFiveCell", for: indexPath) as? PlayerProfileLastFiveTableViewCell,
                let matches = matches,
                let player = player else { return PlayerProfileLastFiveTableViewCell() }
            if matches.count < 5 {
                cell.updateViewsWith(matches: matches, player: player)
            } else {
                cell.updateViewsWith(matches: [matches[0], matches[1], matches[2], matches[3], matches[4]], player: player)
            }
            return cell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "matchCell", for: indexPath) as? PlayerProfileMatchHistoryTableViewCell else { return PlayerProfileMatchHistoryTableViewCell() }
        cell.updateViewsWith(opponent: opponents?[indexPath.row - 2], match: matches?[indexPath.row - 2], player: player)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 44
        }
        return 140
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            title = player?.username
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            title = "Match History"
        }
    }
    
}
