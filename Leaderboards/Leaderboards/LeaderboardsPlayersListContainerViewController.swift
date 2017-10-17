//
//  LeaderboardsPlayersListContainerViewController.swift
//  Leaderboards
//
//  Created by Mithun Reddy on 10/3/17.
//  Copyright © 2017 Jatin Menghani. All rights reserved.
//

import UIKit

class LeaderboardsPlayersListContainerViewController: UIViewController {

    @IBOutlet weak var leaderboardsContainerView: UIView!
    @IBOutlet weak var playersListContainerView: UIView!
    @IBOutlet weak var leaderboardsPlayersButton: UIButton!
    @IBOutlet weak var leaderboardsPlayersListView: UIView!
    @IBOutlet weak var leaderboardsPlayersButtonViewContainer: UIView!
    
    let colorProvider = BackgroundColorProvider()
    var randomColor: UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        leaderboardsPlayersListView.backgroundColor = randomColor
        
        let addMatchBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMatchBarButtonItemTapped))
        navigationItem.rightBarButtonItem = addMatchBarButtonItem
        
        leaderboardsPlayersButtonViewContainer.layer.cornerRadius = 5
        leaderboardsPlayersButtonViewContainer.clipsToBounds = true
        
        leaderboardsPlayersButton.tintColor = randomColor
    }
    
    @IBAction func leaderboardsPlayersButtonTapped(_ sender: Any) {
        if playersListContainerView.alpha == 0 {
            playersListContainerView.alpha = 1
            leaderboardsContainerView.alpha = 0
            leaderboardsPlayersButton.setTitle("Leaderboards", for: .normal)
        } else {
            playersListContainerView.alpha = 0
            leaderboardsContainerView.alpha = 1
            leaderboardsPlayersButton.setTitle("Players", for: .normal)
        }
    }
    
    @objc func addMatchBarButtonItemTapped() {
        let newMatchVC = UIStoryboard(name: "Match", bundle: nil).instantiateViewController(withIdentifier: "newMatchVC")
        present(newMatchVC, animated: true, completion: nil)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toLeaderboardsVC" {
            randomColor = colorProvider.randomColor()
            let leaderboardsVC = segue.destination as? LeaderboardsViewController
            leaderboardsVC?.randomColor = randomColor
        }
        
    }
 

}
