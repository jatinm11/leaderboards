//
//  PendingMatchesViewController.swift
//  Leaderboards
//
//  Created by Jatin Menghani on 25/09/17.
//  Copyright © 2017 Jatin Menghani. All rights reserved.
//

import UIKit
import CloudKit

class PendingMatchesViewController: UIViewController {
    
    let colorProvider = BackgroundColorProvider()
    
    @IBOutlet var approveMessageLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.tableFooterView = UIView()
        
        let randomColor = colorProvider.randomColor()
        tableView.backgroundColor = randomColor
        view.backgroundColor = randomColor
        
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
        dismiss(animated: true, completion: nil)
    }
    
    func updateBadge(number: Int) {
        let operation = CKModifyBadgeOperation(badgeValue: number)
        operation.modifyBadgeCompletionBlock = {(error) in
            if let error = error{
                print("\(error)")
                return
            }
            
            DispatchQueue.main.async {
                UIApplication.shared.applicationIconBadgeNumber = number
            }
        }
        CKContainer.default().add(operation)
    }
    
}


extension PendingMatchesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MatchController.shared.pendingMatches.count + 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "pendingMatchesTitleCell", for: indexPath)
            approveMessageLabel.text = "You have no pending matches."
            return cell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "pendingMatchCell", for: indexPath) as? PendingMatchTableViewCell else { return PendingMatchTableViewCell() }
        cell.updateViewsWith(MatchController.shared.pendingMatches[indexPath.row - 1])
        approveMessageLabel.text = " Swipe to approve or decline matches."
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 44
        }
        return 135
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == 0 {
            return false
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if indexPath.row == 0 {
            return nil
        }
        
        let confirmTableViewRowAction = UITableViewRowAction(style: .normal, title: "Approve") { (_, indexPath) in
            let verifiedMatch = MatchController.shared.verifyMatch(MatchController.shared.pendingMatches[indexPath.row - 1])
            MatchController.shared.updateMatch(verifiedMatch, completion: { (success) in
                if success {
                    DispatchQueue.main.async {
                        MatchController.shared.clearPendingMatch(at: indexPath.row - 1)
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                        self.updateBadge(number: MatchController.shared.pendingMatches.count)
                    }
                }
            })
        }
        
        let denyTableViewRowAction = UITableViewRowAction(style: .destructive, title: "Decline") { (_, indexPath) in
            MatchController.shared.deletePendingMatch(at: indexPath.row - 1, completion: { (success) in
                if success {
                    DispatchQueue.main.async {
                        MatchController.shared.clearPendingMatch(at: indexPath.row - 1)
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                        self.updateBadge(number: MatchController.shared.pendingMatches.count)
                    }
                }
            })
        }
        
        confirmTableViewRowAction.backgroundColor = .green
        denyTableViewRowAction.backgroundColor = .red
        
        return [confirmTableViewRowAction, denyTableViewRowAction]
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            navigationBar.topItem?.title = ""
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            navigationBar.topItem?.title = "Pending Matches"
        }
    }
}
