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
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GameController.shared.fetchAllPlayersForCurrentGame { (success) in
            DispatchQueue.main.async {
                self.playerTableView.reloadData()
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
        cell.backgroundColor = UIColor.clear
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }

}
