//
//  PlayerDetailsViewController.swift
//  Leaderboards
//
//  Created by Jatin Menghani on 25/09/17.
//  Copyright © 2017 Jatin Menghani. All rights reserved.
//

import UIKit

class PlayerDetailsViewController: UIViewController {

    
    @IBOutlet var playerImageView: UIImageView!
    @IBOutlet var playerNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        PlayerController.shared.fetchCurrentPlayer { (success) in
            if success {
                DispatchQueue.main.async {
                    self.playerImageView.image = PlayerController.shared.currentPlayer?.photo
                    self.playerNameLabel.text = PlayerController.shared.currentPlayer?.username
                }
            }
        }
        
    }

    

}
