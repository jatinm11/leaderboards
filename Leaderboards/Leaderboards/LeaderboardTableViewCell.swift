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
    @IBOutlet var winPercentageLabel: UILabel!
    @IBOutlet var playerName: UILabel!
    
    // MARK :- Functions
    
    func updateViewsWith(playerDictionary: [String: Any]?) {
        playerImage.image = (playerDictionary?["player"] as? Player)?.photo
        playerName.text = (playerDictionary?["player"] as? Player)?.username
        matchesPlayedLabel.text = "\(playerDictionary?["played"] ?? 0)"
        matchesWonLabel.text = "\(playerDictionary?["wins"] ?? 0)"
        matchesLossLabel.text = "\(playerDictionary?["losses"] ?? 0)"
        if let winPercentage = playerDictionary?["winPercentage"] as? Double {
            winPercentageLabel.text = "\(Int(winPercentage * 100))"
        }
        playerImage.layer.cornerRadius = playerImage.frame.width / 2
        playerImage.clipsToBounds = true
    }
}
