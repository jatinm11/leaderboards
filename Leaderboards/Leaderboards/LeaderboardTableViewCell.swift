//
//  LeaderboardTableViewCell.swift
//  Leaderboards
//
//  Created by Jatin Menghani on 19/09/17.
//  Copyright © 2017 Jatin Menghani. All rights reserved.
//

import UIKit

class LeaderboardTableViewCell: UITableViewCell {
    
    // MARK:- Outlets
    
    @IBOutlet var playerImage: UIImageView!
    @IBOutlet var matchesPlayedLabel: UILabel!
    @IBOutlet var matchesWonLabel: UILabel!
    @IBOutlet var matchesLossLabel: UILabel!
    @IBOutlet var totalPointsLabel: UILabel!
    
    // MARK :- Properties
    
    var player: Player? {
        didSet {
            updateName()
        }
    }
    
    // MARK :- Functions
    
    func updateName() {
        if let player = player {
            playerImage.image = player.photo
        }
    }
}
