//
//  PlayerProfileViewController.swift
//  Leaderboards
//
//  Created by Mithun Reddy on 9/21/17.
//  Copyright © 2017 Jatin Menghani. All rights reserved.
//

import UIKit

class PlayerProfileViewController: UIViewController {
    
    @IBOutlet weak var playerImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var pendingMatchesView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func backBarButtonItemTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func segmentedControlSegmentChanged(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            profileView.alpha = 1
            pendingMatchesView.alpha = 0
        case 1:
            profileView.alpha = 0
            pendingMatchesView.alpha = 1
        default:
            break
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        pendingMatchesView.alpha = 0
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        PlayerController.shared.fetchCurrentPlayer { (success) in
            if success {
                DispatchQueue.main.async {
                    self.playerImageView.image = PlayerController.shared.currentPlayer?.photo
                    self.usernameLabel.text = PlayerController.shared.currentPlayer?.username
                    MatchController.shared.fetchPendingMatchesForCurrentPlayer { (success) in
                        if success {
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension PlayerProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MatchController.shared.pendingMatches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "pendingMatchCell", for: indexPath) as? PendingMatchTableViewCell else { return PendingMatchTableViewCell() }
        cell.updateViewsWith(MatchController.shared.pendingMatches[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let confirmTableViewRowAction = UITableViewRowAction(style: .normal, title: "Confirm") { (_, indexPath) in
            let verifiedMatch = MatchController.shared.verifyMatch(MatchController.shared.pendingMatches[indexPath.row])
            MatchController.shared.updateMatch(verifiedMatch, completion: { (success) in
                if success {
                    DispatchQueue.main.async {
                        MatchController.shared.clearPendingMatch(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                    }
                }
            })
        }
        
        let denyTableViewRowAction = UITableViewRowAction(style: .destructive, title: "Deny") { (_, indexPath) in
            MatchController.shared.deletePendingMatch(at: indexPath.row, completion: { (success) in
                if success {
                    DispatchQueue.main.async {
                        MatchController.shared.clearPendingMatch(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                    }
                }
            })
        }
        
        return [confirmTableViewRowAction, denyTableViewRowAction]
    }
    
}
