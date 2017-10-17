//
//  CurrentPlayerMatchHistoryTableViewCell.swift
//  Leaderboards
//
//  Created by Mithun Reddy on 10/4/17.
//  Copyright © 2017 Jatin Menghani. All rights reserved.
//

import UIKit

class CurrentPlayerMatchHistoryTableViewCell: UITableViewCell {

    @IBOutlet var playerImage: UIImageView!
    @IBOutlet var playerName: UILabel!
    @IBOutlet weak var opponentImage: UIImageView!
    @IBOutlet weak var opponentUsername: UILabel!
    @IBOutlet weak var gameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet var scoreView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        playerImage.layer.cornerRadius = playerImage.frame.width / 2
        playerImage.clipsToBounds = true
        playerImage.layer.borderWidth = 2.0
        playerImage.layer.borderColor = UIColor.white.cgColor
        
        opponentImage.layer.cornerRadius = opponentImage.frame.width / 2
        opponentImage.clipsToBounds = true
        opponentImage.layer.borderWidth = 2.0
        opponentImage.layer.borderColor = UIColor.white.cgColor
        
        scoreView.layer.cornerRadius = 5
        scoreView.clipsToBounds = true
     
        if let player = PlayerController.shared.currentPlayer {
            playerImage.image = player.photo
            playerName.text = player.username
        }
    }
    
    
    func updateViewsWith(opponent: Player?, match: Match?, game: Game?) {
        guard let match = match else { return }
        gameLabel.text = game?.name
        opponentImage.image = opponent?.photo
        opponentUsername.text = opponent?.username
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        timestampLabel.text = dateFormatter.string(from:  match.timestamp)
        if let currentPlayer = PlayerController.shared.currentPlayer {
            if match.winner.recordID == currentPlayer.recordID {
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
    

}
