//
//  PlayerViewController.swift
//  Leaderboards
//
//  Created by Jatin Menghani on 19/09/17.
//  Copyright © 2017 Jatin Menghani. All rights reserved.
//

import UIKit

class PlayerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let colorProvider = BackgroundColorProvider()
    @IBOutlet var playerTableView: UITableView!
    @IBOutlet var leaderboardsButton: UIBarButtonItem!
    @IBOutlet var backButton: UIBarButtonItem!
    @IBOutlet var navigationBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playerTableView.delegate = self
        playerTableView.dataSource = self
        let randomColor = colorProvider.randomColor()
        self.view.backgroundColor = randomColor
        self.playerTableView.backgroundColor = randomColor
        self.backButton.tintColor = randomColor
        self.leaderboardsButton.tintColor = randomColor
        self.navigationBar.layer.cornerRadius = 5
        self.navigationBar.clipsToBounds = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    @IBAction func leaderboardsButtonTapped(_ sender: Any) {
        let leaderboardsVC = UIStoryboard(name: "Leaderboards", bundle: nil).instantiateViewController(withIdentifier: "leaderboardsVC")
        self.present(leaderboardsVC, animated: true, completion: nil)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        GameController.shared.playersBelongingToCurrentGame = []
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GameController.shared.fetchAllPlayersForCurrentGame { (_) in
            DispatchQueue.main.async {
                self.animateTable()
            }
        }
    }
    
    // MARK:- TableView data source.
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GameController.shared.playersBelongingToCurrentGame.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playerCell", for: indexPath) as! PlayerTableViewCell
        let player = GameController.shared.playersBelongingToCurrentGame[indexPath.row]
        cell.player = player
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        cell.backgroundColor = UIColor.clear
        UIView.animate(withDuration: 1.0) {
            cell.alpha = 1.0
        }
    }
    
    func animateTable() {
        playerTableView.reloadData()
        let cells = playerTableView.visibleCells
        
        let tableViewHeight = playerTableView.bounds.size.height
        
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        
        var delayCounter = 0
        for cell in cells {
            UIView.animate(withDuration: 1.0, delay: Double(delayCounter) * 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
                }, completion: nil)
            delayCounter += 1
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}










