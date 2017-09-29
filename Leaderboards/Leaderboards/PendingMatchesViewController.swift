//
//  PendingMatchesViewController.swift
//  Leaderboards
//
//  Created by Jatin Menghani on 25/09/17.
//  Copyright © 2017 Jatin Menghani. All rights reserved.
//

import UIKit

class PendingMatchesViewController: UIViewController {
    
    let colorProvider = BackgroundColorProvider()
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var navigationBar: UINavigationBar!
    @IBOutlet var backButton: UIBarButtonItem!
    @IBOutlet var myProfileBarButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        let randomColor = colorProvider.randomColor()
        tableView.backgroundColor = randomColor
        self.view.backgroundColor = randomColor
        self.myProfileBarButton.tintColor = randomColor
        self.backButton.tintColor = randomColor
        self.navigationBar.layer.cornerRadius = 5
        self.navigationBar.clipsToBounds = true
        
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        MatchController.shared.fetchPendingMatchesForCurrentPlayer { (success) in
            if success {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "toApprovalVC" {
//            if let indexPath = tableView.indexPathForSelectedRow, let cell = tableView.cellForRow(at: indexPath) as? PendingMatchTableViewCell, let destination = segue.destination as? ApprovalViewController {
//                destination.game = cell.gameLabel.text!
//                destination.date = cell.dateLabel.text!
//                destination.opponent = cell.opponentLabel.text!
//                destination.score = cell.scoreLabel.text!
//                destination.matchIndex = indexPath.row
//                let match = MatchController.shared.pendingMatches[indexPath.row]
//                MatchController.shared.fetchOpponentImageFor(match, completion: { (opponent, success) in
//                    if success {
//                        DispatchQueue.main.async {
//                            destination.playerImageView.image = opponent?.photo
//                            destination.playerImageView.layer.cornerRadius = destination.playerImageView.frame.width / 2
//                            destination.playerImageView.clipsToBounds = true
//                            destination.playerImageView.layer.borderColor = UIColor.white.cgColor
//                            destination.playerImageView.layer.borderWidth = 3.0
//                        }
//                    }
//                })
//            }
//        }
//    }
}


extension PendingMatchesViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MatchController.shared.pendingMatches.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "pendingMatchCell", for: indexPath) as? PendingMatchTableViewCell else { return PendingMatchTableViewCell() }
        cell.updateViewsWith(MatchController.shared.pendingMatches[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        
        let confirmTableViewRowAction = UITableViewRowAction(style: .normal, title: "Approve") { (_, indexPath) in
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
        
        let denyTableViewRowAction = UITableViewRowAction(style: .destructive, title: "Decline") { (_, indexPath) in
            MatchController.shared.deletePendingMatch(at: indexPath.row, completion: { (success) in
                if success {
                    DispatchQueue.main.async {
                        MatchController.shared.clearPendingMatch(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                    }
                }
            })
        }
        
        confirmTableViewRowAction.backgroundColor = .green
        denyTableViewRowAction.backgroundColor = .red
        
        return [confirmTableViewRowAction, denyTableViewRowAction]
    }
}

// ------------------------------------------------------------------------------------------------------------------------------------------------
// ------------------------------------------------------------------------------------------------------------------------------------------------
//                let match = MatchController.shared.pendingMatches[indexPath.row]
//                MatchController.shared.fetchGameAndOpponentFor(match, completion: { (game, opponent, success) in
//                    if success {
//                        DispatchQueue.main.async {
//                            destination.gameLabel.text = game?.name
//                            destination.opponentLabel.text = opponent?.username
//                            destination.playerImageView.image = opponent?.photo
//                            destination.scoreLabel.text = "\(match.winnerScore) - \(match.loserScore)"
//                            let dateFormatter = DateFormatter()
//                            dateFormatter.dateStyle = .full
//                            destination.dateLabel.text = dateFormatter.string(from: match.timestamp)
//                        }
//                    }
//                })
