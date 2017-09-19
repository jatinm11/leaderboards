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
    
    @IBOutlet var playerImageView: UIImageView!
    @IBOutlet var playerNameLabel: UILabel!
    
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
        }
    }
}
