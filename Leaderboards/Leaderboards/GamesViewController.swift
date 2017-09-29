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
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var playerImageView: UIImageView!
    
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
        
        if let currentPlayer = PlayerController.shared.currentPlayer {
            playerImageView.image = currentPlayer.photo
            playerImageView.layer.cornerRadius = self.playerImageView.frame.width / 2
            playerImageView.layer.borderColor = UIColor.white.cgColor
            playerImageView.layer.borderWidth = 3.0
            playerImageView.clipsToBounds = true
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension GamesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GameController.shared.gamesBelongingToCurrentPlayer.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == GameController.shared.gamesBelongingToCurrentPlayer.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addGameCell", for: indexPath)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath)
        cell.textLabel?.text = ("\(GameController.shared.gamesBelongingToCurrentPlayer[indexPath.row].name)")
        cell.detailTextLabel?.textColor = UIColor.white
        cell.textLabel?.textColor = UIColor.white
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == GameController.shared.gamesBelongingToCurrentPlayer.count {
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
        } else {
            GameController.shared.currentGame = GameController.shared.gamesBelongingToCurrentPlayer[indexPath.row]
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
}
