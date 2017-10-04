//
//  CurrentPlayerMatchHistoryTableViewCell.swift
//  Leaderboards
//
//  Created by Mithun Reddy on 10/4/17.
//  Copyright © 2017 Jatin Menghani. All rights reserved.
//

import UIKit

class CurrentPlayerMatchHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var opponentImage: UIImageView!
    @IBOutlet weak var opponentUsername: UILabel!
    @IBOutlet weak var gameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
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
                self.scoreLabel.text = "\(match.winnerScore) - \(match.loserScore)"
            } else {
                // current player lost
                self.scoreLabel.text = "\(match.loserScore) - \(match.winnerScore)"
            }
        }
    }
    

}
