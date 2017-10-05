//
//  PlayersListViewController.swift
//  Leaderboards
//
//  Created by Mithun Reddy on 10/3/17.
//  Copyright © 2017 Jatin Menghani. All rights reserved.
//

import UIKit

class PlayersListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: LeaderboardsViewController.fetchAllPlayersComplete, object: nil)
    }
    
    @objc func reloadTableView() {
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPlayerDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let playerProfileVC = segue.destination as? PlayerProfileViewController
            playerProfileVC?.player = GameController.shared.playersBelongingToCurrentGame[indexPath.row - 1]
        }
    }
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension PlayersListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GameController.shared.playersBelongingToCurrentGame.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "playersTitleCell", for: indexPath)
            return cell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "playerCell", for: indexPath) as? PlayerTableViewCell else { return PlayerTableViewCell() }
        let player = GameController.shared.playersBelongingToCurrentGame[indexPath.row - 1]
        cell.player = player
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 44
        }
        return 87
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            navigationController?.topViewController?.title = GameController.shared.currentGame?.name
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            navigationController?.topViewController?.title = "Players"
        }
    }
    
}
