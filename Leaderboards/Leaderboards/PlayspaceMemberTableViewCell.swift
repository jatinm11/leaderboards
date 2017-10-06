//
//  PlayspaceMemberTableViewCell.swift
//  Leaderboards
//
//  Created by Mithun Reddy on 10/5/17.
//  Copyright © 2017 Jatin Menghani. All rights reserved.
//

import UIKit

class PlayspaceMemberTableViewCell: UITableViewCell {

    @IBOutlet weak var playerImageView: UIImageView!
    @IBOutlet weak var playerNameLabel: UILabel!
    
    func updateViewWith(member: Player?) {
        playerImageView.layer.cornerRadius = playerImageView.frame.size.width / 2
        playerImageView.clipsToBounds = true
        playerImageView.image = member?.photo
        playerNameLabel.text = member?.username
    }
    
}
