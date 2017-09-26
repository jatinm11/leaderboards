//
//  TournamentsListViewController.swift
//  Leaderboards
//
//  Created by Mithun Reddy on 9/26/17.
//  Copyright © 2017 Jatin Menghani. All rights reserved.
//

import UIKit

class TournamentsListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        TournamentController.shared.fetchTournamentsForCurrentGame { (success) in
            if success {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }

}

extension TournamentsListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TournamentController.shared.tournamentsBelongingToCurrentPlayer.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tournamentCell", for: indexPath)
        cell.textLabel?.text = TournamentController.shared.tournamentsBelongingToCurrentPlayer[indexPath.row].name
        return cell
    }
    
}
