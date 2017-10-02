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
    
    
    func updateViewsWith(_ pendingMatch: Match) {
        MatchController.shared.fetchGameAndOpponentFor(pendingMatch) { (game, opponent, success) in
            if success {
                DispatchQueue.main.async {
                    self.gameLabel.text = game?.name
                    self.opponentLabel.text = opponent?.username
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateStyle = .full
                    self.dateLabel.text = dateFormatter.string(from: pendingMatch.timestamp)
                    
                    if let currentPlayer = PlayerController.shared.currentPlayer {
                        if pendingMatch.winner.recordID == currentPlayer.recordID {
                            // current player won
                            self.scoreLabel.text = "\(pendingMatch.winnerScore) - \(pendingMatch.loserScore)"
                        } else {
                            // current player lost
                            self.scoreLabel.text = "\(pendingMatch.loserScore) - \(pendingMatch.winnerScore)"
                        }
                    }
                }
            }
        }
    }
}
