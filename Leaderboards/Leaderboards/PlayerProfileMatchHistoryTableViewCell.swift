//
//  PlayerProfileMatchHistoryTableViewCell.swift
//  Leaderboards
//
//  Created by Mithun Reddy on 10/4/17.
//  Copyright © 2017 Jatin Menghani. All rights reserved.
//

import UIKit

class PlayerProfileMatchHistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var opponentImage: UIImageView!
    @IBOutlet weak var opponentUsername: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet var scoreView: UIView!
    @IBOutlet var playerNameLabel: UILabel!
    @IBOutlet var playerImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        scoreView.layer.cornerRadius = 5
        scoreView.clipsToBounds = true
        playerImage.layer.cornerRadius = playerImage.frame.width / 2
        playerImage.clipsToBounds = true
        playerImage.layer.borderColor = UIColor.white.cgColor
        playerImage.layer.borderWidth = 2.0
    }
    
    func updateViewsWith(opponent: Player?, match: Match?, player: Player?) {
        guard let match = match else { return }
        if let player = player {
            playerNameLabel.text = player.username
            playerImage.image = player.photo
        }
        opponentImage.image = opponent?.photo
        opponentImage.layer.cornerRadius = opponentImage.frame.width / 2
        opponentImage.layer.borderWidth = 2.0
        opponentImage.clipsToBounds = true
        opponentImage.layer.borderColor = UIColor.white.cgColor
        opponentUsername.text = opponent?.username
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        timestampLabel.text = dateFormatter.string(from:  match.timestamp)
        guard let player = player else { return }
        if match.winner.recordID == player.recordID {
            // current player won
            self.scoreView.backgroundColor = UIColor(red: 52.0/255.0, green: 216.0/255.0, blue: 132.0/255.0, alpha: 1.0)
            self.scoreLabel.text = "\(match.winnerScore) - \(match.loserScore)"
        } else {
            // current player lost
            self.scoreView.backgroundColor = UIColor.red
            self.scoreLabel.text = "\(match.loserScore) - \(match.winnerScore)"
        }
    }
}
