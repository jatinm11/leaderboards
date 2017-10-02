//
//  GameStatsTableViewCell.swift
//  Leaderboards
//
//  Created by Mithun Reddy on 10/1/17.
//  Copyright © 2017 Jatin Menghani. All rights reserved.
//

import UIKit

class GameStatsTableViewCell: UITableViewCell {

    @IBOutlet weak var playedLabel: UILabel!
    @IBOutlet weak var winsLabel: UILabel!
    @IBOutlet weak var lossesLabel: UILabel!
    @IBOutlet weak var winPercentageLabel: UILabel!
    @IBOutlet weak var pointsForLabel: UILabel!
    @IBOutlet weak var pointsAgainstLabel: UILabel!
    
    func updateViewsWith(_ gameDictionary: [String: Any]) {
        guard let played = gameDictionary["played"] as? Int,
            let wins = gameDictionary["wins"] as? Int,
            let losses = gameDictionary["losses"] as? Int,
            let winPercentage = gameDictionary["winPercentage"] as? Double,
            let pointsFor = gameDictionary["pointsFor"] as? Int,
            let pointsAgainst = gameDictionary["pointsAgainst"] as? Int else { return }
        
        playedLabel.text = "\(played)"
        winsLabel.text = "\(wins)"
        lossesLabel.text = "\(losses)"
        winPercentageLabel.text = "\(winPercentage)"
        pointsForLabel.text = "\(pointsFor)"
        pointsAgainstLabel.text = "\(pointsAgainst)"
    }

}
