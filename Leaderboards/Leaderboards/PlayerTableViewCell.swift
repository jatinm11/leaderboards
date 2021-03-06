//
//  PlayerTableViewCell.swift
//  Leaderboards
//
//  Created by Jatin Menghani on 19/09/17.
//  Copyright © 2017 Jatin Menghani. All rights reserved.
//

import UIKit

class PlayerTableViewCell: UITableViewCell {

    // MARK:- Outlets
    
    @IBOutlet weak var playerImageView: UIImageView!
    @IBOutlet weak var playerNameLabel: UILabel!
    
    // MARK:- Properties
    
    var player: Player? {
        didSet {
            updateViews()
        }
    }
    
    // MARK :- Functions
    
    func updateViews() {
        if let player = player {
            playerNameLabel.text = player.username
            playerImageView.image = player.photo
            playerImageView.layer.cornerRadius = playerImageView.frame.size.width / 2
            playerImageView.clipsToBounds = true
            playerNameLabel.textColor = UIColor.white
        }
    }
}
