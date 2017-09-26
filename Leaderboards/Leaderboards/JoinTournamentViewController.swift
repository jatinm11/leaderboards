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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        TournamentController.shared.joinTournamentForCurrentPlayer(TournamentController.shared.tournamentsNotBelongingToCurrentPlayer[indexPath.row]) { (success) in
            if success {
                DispatchQueue.main.async {
                    let waitingForTournamentStartVC = UIStoryboard(name: "Tournament", bundle: nil).instantiateViewController(withIdentifier: "waitingForTournamentStartVC")
                    self.present(waitingForTournamentStartVC, animated: true, completion: nil)
                }
            }
        }
    }
    
}
