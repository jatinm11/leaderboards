//
//  JoinTournamentViewController.swift
//  Leaderboards
//
//  Created by Mithun Reddy on 9/26/17.
//  Copyright © 2017 Jatin Menghani. All rights reserved.
//

import UIKit

class JoinTournamentViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toWaitingForTournamentStart" {
            
        }
    }

}

extension JoinTournamentViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TournamentController.shared.tournamentsNotBelongingToCurrentPlayer.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tournamentCell", for: indexPath)
        cell.textLabel?.text = TournamentController.shared.tournamentsNotBelongingToCurrentPlayer[indexPath.count].name
        return cell
    }
    
}
