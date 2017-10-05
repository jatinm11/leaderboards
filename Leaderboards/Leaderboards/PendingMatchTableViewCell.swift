//
//  PendingMatchTableViewCell.swift
//  Leaderboards
//
//  Created by Mithun Reddy on 9/21/17.
//  Copyright © 2017 Jatin Menghani. All rights reserved.
//

import UIKit

class PendingMatchTableViewCell: UITableViewCell {

    @IBOutlet weak var gameLabel: UILabel!
    @IBOutlet weak var opponentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var opponentImage: UIImageView!
    
    
    func updateViewsWith(_ pendingMatch: Match) {
        MatchController.shared.fetchGameAndOpponentFor(pendingMatch) { (game, opponent, success) in
            if success {
                DispatchQueue.main.async {
                    self.opponentImage.image = opponent?.photo
                    self.opponentImage.layer.cornerRadius = self.opponentImage.frame.size.width / 2
                    self.opponentImage.clipsToBounds = true
                    self.gameLabel.text = game?.name
                    self.opponentLabel.text = opponent?.username
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateStyle = .medium
                    self.dateLabel.text = dateFormatter.string(from: pendingMatch.timestamp)
                    if let currentPlayer = PlayerController.shared.currentPlayer {
                        if pendingMatch.winner.recordID == currentPlayer.recordID {
                            // current player won
                            self.opponentImage.layer.borderColor = UIColor(red: 52.0/255.0, green: 216.0/255.0, blue: 132.0/255.0, alpha: 1.0).cgColor
                            self.opponentImage.layer.borderWidth = 3.0
                            self.scoreLabel.text = "\(pendingMatch.winnerScore) - \(pendingMatch.loserScore)"
                        } else {
                            // current player lost
                            self.opponentImage.layer.borderColor = UIColor.red.cgColor
                            self.opponentImage.layer.borderWidth = 3.0
                            self.scoreLabel.text = "\(pendingMatch.loserScore) - \(pendingMatch.winnerScore)"
                        }
                    }
                }
            }
        }
    }
}
