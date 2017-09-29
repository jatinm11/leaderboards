//
//  GamesViewController.swift
//  Leaderboards
//
//  Created by Mithun Reddy on 9/20/17.
//  Copyright © 2017 Jatin Menghani. All rights reserved.
//

import UIKit

class GamesViewController: UIViewController {
    
    let colorProvider = BackgroundColorProvider()
    
    @IBOutlet var notificationCountLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var playerImageView: UIImageView!
    @IBOutlet var notificationViewBadge: UIView!
    @IBOutlet var addgameButtonViewContainer: UIView!
    @IBOutlet var addGameButton: UIButton!
    
    @IBAction func swipeGestureSwiped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        let randomColor = colorProvider.randomColor()
        self.tableView.backgroundColor = randomColor
        self.view.backgroundColor = randomColor
        self.notificationCountLabel.textColor = randomColor
        self.notificationCountLabel.tintColor = randomColor
        self.addGameButton.tintColor = randomColor
        self.addgameButtonViewContainer.layer.cornerRadius = 5
        self.addgameButtonViewContainer.clipsToBounds = true
        
        GameController.shared.fetchGamesForCurrentPlayspace { (success) in
            if success {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
        
        MatchController.shared.fetchPendingMatchesForCurrentPlayer { (success) in
            if success {
                DispatchQueue.main.async {
                    if let currentPlayer = PlayerController.shared.currentPlayer {
                        self.notificationViewBadge.isHidden = true
                        self.playerImageView.image = currentPlayer.photo
                        self.playerImageView.layer.cornerRadius = self.playerImageView.frame.width / 2
                        self.playerImageView.layer.borderColor = UIColor.white.cgColor
                        self.playerImageView.layer.borderWidth = 3.0
                        self.playerImageView.clipsToBounds = true
                        if MatchController.shared.pendingMatches.count > 0 {
                            self.notificationViewBadge.isHidden = false
                            self.notificationCountLabel.text = "\(MatchController.shared.pendingMatches.count)"
                            self.notificationViewBadge.layer.cornerRadius = self.notificationViewBadge.frame.width / 2
                            self.notificationViewBadge.layer.borderColor = UIColor.white.cgColor
                            self.notificationViewBadge.layer.borderWidth = 3.0
                            self.notificationViewBadge.clipsToBounds = true
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension GamesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GameController.shared.gamesBelongingToCurrentPlayer.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath)
        cell.textLabel?.text = ("\(GameController.shared.gamesBelongingToCurrentPlayer[indexPath.row].name)")
        cell.detailTextLabel?.textColor = UIColor.white
        cell.textLabel?.textColor = UIColor.white
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        GameController.shared.currentGame = GameController.shared.gamesBelongingToCurrentPlayer[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
}
