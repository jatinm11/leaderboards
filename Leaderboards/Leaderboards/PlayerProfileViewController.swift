//
//  PlayerProfileViewController.swift
//  Leaderboards
//
//  Created by Jatin Menghani on 21/09/17.
//  Copyright © 2017 Jatin Menghani. All rights reserved.
//

import UIKit

class PlayerProfileViewController: UIViewController {

    var player = GameController.shared.playersBelongingToCurrentGame
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        playerNameLabel.text = player[0].username
        playerImageView.image = player[0].photo
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GameController.shared.fetchAllPlayersForCurrentGame { (success) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var playerNameLabel: UILabel!
    @IBOutlet var playerImageView: UIImageView!
    
}


extension PlayerProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GameController.shared.playersBelongingToCurrentGame.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath)
        let player = GameController.shared.playersBelongingToCurrentGame[indexPath.row]
        cell.textLabel?.text = player.username
        return cell
    }
    
}
