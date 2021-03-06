//
//  GamesViewController.swift
//  Leaderboards
//
//  Created by Mithun Reddy on 9/20/17.
//  Copyright © 2017 Jatin Menghani. All rights reserved.
//

import UIKit
import CloudKit

class GamesViewController: UIViewController {
    
    let colorProvider = BackgroundColorProvider()
    
    @IBOutlet var nogamesView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addgameButtonViewContainer: UIView!
    @IBOutlet weak var addGameButton: UIButton!
    
    var isFirstTime = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        let randomColor = colorProvider.randomColor()
        tableView.backgroundColor = randomColor
        view.backgroundColor = randomColor
        addGameButton.tintColor = randomColor
        nogamesView.backgroundColor = randomColor
        addgameButtonViewContainer.layer.cornerRadius = 5
        addgameButtonViewContainer.clipsToBounds = true
        
        self.nogamesView.isHidden = true
        
        GameController.shared.fetchGamesForCurrentPlayspace { (success) in
            if success {
                DispatchQueue.main.async {
                    if GameController.shared.gamesBelongingToCurrentPlayer.count == 0 {
                        self.nogamesView.isHidden = false
                    }
                    else {
                        self.nogamesView.isHidden = true
                    }
                    self.isFirstTime = false
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !isFirstTime{
            if GameController.shared.gamesBelongingToCurrentPlayer.count == 0 {
                self.nogamesView.isHidden = false
            }
            else {
                self.nogamesView.isHidden = true
            }
        }
        
        tableView.reloadData()
        
        if let currentPlayer = PlayerController.shared.currentPlayer {
            let playerImageButton = UIButton(type: .custom)
            playerImageButton.addTarget(self, action: #selector(playerImageButtonTapped), for: .touchUpInside)
            playerImageButton.setImage(currentPlayer.photo, for: .normal)
            playerImageButton.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
            playerImageButton.layer.cornerRadius = playerImageButton.frame.height / 2
            playerImageButton.clipsToBounds = true
            playerImageButton.layer.borderColor = UIColor.white.cgColor
            playerImageButton.layer.borderWidth = 2.0
            playerImageButton.addConstraint(NSLayoutConstraint(item: playerImageButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 32))
            playerImageButton.addConstraint(NSLayoutConstraint(item: playerImageButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 32))
            
            let shareShowPasswordButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareShowPasswordButtonTapped))
            
            let pendingMatchesNotificationBadgeButton = UIButton(type: .system)
            pendingMatchesNotificationBadgeButton.addTarget(self, action: #selector(pendingMatchesNotificationBadgeButtonTapped), for: .touchUpInside)
            pendingMatchesNotificationBadgeButton.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
            pendingMatchesNotificationBadgeButton.backgroundColor = .white
            pendingMatchesNotificationBadgeButton.tintColor = view.backgroundColor
            pendingMatchesNotificationBadgeButton.layer.cornerRadius = pendingMatchesNotificationBadgeButton.frame.height / 2
            pendingMatchesNotificationBadgeButton.clipsToBounds = true
            pendingMatchesNotificationBadgeButton.layer.borderColor = UIColor.white.cgColor
            pendingMatchesNotificationBadgeButton.layer.borderWidth = 1.0
            
            MatchController.shared.fetchPendingMatchesForCurrentPlayer { (success) in
                if success {
                    DispatchQueue.main.async {
                        let operation = CKModifyBadgeOperation(badgeValue: MatchController.shared.pendingMatches.count)
                        operation.modifyBadgeCompletionBlock = {(error) in
                            if let error = error{
                                print("\(error)")
                                return
                            }
                            
                            DispatchQueue.main.async {
                                UIApplication.shared.applicationIconBadgeNumber = MatchController.shared.pendingMatches.count
                            }
                        }
                        CKContainer.default().add(operation)
                        if MatchController.shared.pendingMatches.count > 0 {
                            pendingMatchesNotificationBadgeButton.setTitle("\(MatchController.shared.pendingMatches.count)", for: .normal)
                            self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: playerImageButton), UIBarButtonItem(customView: pendingMatchesNotificationBadgeButton), shareShowPasswordButton]
                        } else {
                            self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: playerImageButton), shareShowPasswordButton]
                        }
                    }
                }
            }
        }
        
    }
    
    @IBAction func addGameButtonTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "Add Game", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Join Game", style: .default , handler: { (_) -> Void in
            let joinGameVC = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "joinGameVC")
            self.present(joinGameVC, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "New Game", style: .default, handler: { (_) -> Void in
            let newGameVC = UIStoryboard(name: "NewGame", bundle: nil).instantiateViewController(withIdentifier: "newGameVC")
            self.present(newGameVC, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc func playerImageButtonTapped() {
        let currentPlayerProfileVC = UIStoryboard(name: "PlayerProfile", bundle: nil).instantiateViewController(withIdentifier: "currentPlayerProfileContainerVC")
        present(currentPlayerProfileVC, animated: true, completion: nil)
    }
    
    @objc func pendingMatchesNotificationBadgeButtonTapped() {
        let pendingMatchesVC = UIStoryboard(name: "PlayerProfile", bundle: nil).instantiateViewController(withIdentifier: "pendingMatchesVC")
        present(pendingMatchesVC, animated: true, completion: nil)
    }
    
    @objc func shareShowPasswordButtonTapped() {
        guard let playspacePassword = PlayspaceController.shared.currentPlayspace?.password, let playspaceName = PlayspaceController.shared.currentPlayspace?.name else { return }
        let textToShare = "Hey come join me at my playspace \(playspaceName) the password to join is: \(playspacePassword)"
        let share = [textToShare]
        let activityVC = UIActivityViewController(activityItems: share, applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toGameDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            GameController.shared.currentGame = GameController.shared.gamesBelongingToCurrentPlayer[indexPath.row - 1]
        }
    }
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension GamesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GameController.shared.gamesBelongingToCurrentPlayer.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "gamesTitleCell", for: indexPath)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath)
        cell.textLabel?.text = ("\(GameController.shared.gamesBelongingToCurrentPlayer[indexPath.row - 1].name)")
        cell.detailTextLabel?.textColor = UIColor.white
        cell.textLabel?.textColor = UIColor.white
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            navigationItem.title = PlayspaceController.shared.currentPlayspace?.name
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            navigationItem.title = "Games"
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let leaveTableViewRowAction = UITableViewRowAction(style: .normal, title: "Leave") { (_, indexPath) in
            let game = GameController.shared.gamesBelongingToCurrentPlayer[indexPath.row - 1]
            
            GameController.shared.removeCurrentPlayerFrom2(game, completion: { (game, success) in
                if success {
                    DispatchQueue.main.async {
                        guard let game = game else { return }
                        GameController.shared.gamesBelongingToCurrentPlayer.remove(at: indexPath.row - 1)
                        GameController.shared.gamesNotBelongingToCurrentPlayer.append(game)
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                    }
                }
            })
        }
        
        leaveTableViewRowAction.backgroundColor = .red
        
        return [leaveTableViewRowAction]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == 0 {
            return false
        }
        return true
    }
    
}
