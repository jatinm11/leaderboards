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
    
    @IBOutlet var joinGameButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var addGameButton: UIBarButtonItem!
    @IBOutlet var navigationBar: UINavigationBar!
    @IBOutlet var playerImageView: UIImageView!
    
    @IBAction func addGameBarButtonItemTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Add New Game", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Enter Name"
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (_) in
            guard let name = alert.textFields?.first?.text, !name.isEmpty else { return }
            
            GameController.shared.createGameWith(name: name, completion: { (success) in
                if success {
                    //dismiss here
                }
            })
            self.tableView.reloadData()
            
        }))
        present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        let randomColor = colorProvider.randomColor()
        self.tableView.backgroundColor = randomColor
        self.view.backgroundColor = randomColor
        self.joinGameButton.tintColor = randomColor
        self.addGameButton.tintColor = randomColor
        self.navigationBar.layer.cornerRadius = 5
        self.navigationBar.clipsToBounds = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let currentPlayer = PlayerController.shared.currentPlayer {
            GameController.shared.fetchGamesForCurrentPlayspace { (success) in
                if success {
                    DispatchQueue.main.async {
                        self.playerImageView.image = currentPlayer.photo
                        self.playerImageView.layer.cornerRadius = self.playerImageView.frame.width / 2
                        self.playerImageView.layer.borderColor = UIColor.white.cgColor
                        self.playerImageView.layer.borderWidth = 3.0
                        self.playerImageView.clipsToBounds = true
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    @IBAction func goBackSwipeAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension GamesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GameController.shared.gamesBelongingToCurrentPlayer.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath)
        cell.textLabel?.text = ("\(indexPath.row + 1)) \(GameController.shared.gamesBelongingToCurrentPlayer[indexPath.row].name)")
        cell.detailTextLabel?.text = ">"
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
