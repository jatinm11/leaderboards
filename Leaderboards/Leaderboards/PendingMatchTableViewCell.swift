//
//  PendingMatchTableViewCell.swift
//  Leaderboards
//
//  Created by Mithun Reddy on 9/21/17.
//  Copyright © 2017 Jatin Menghani. All rights reserved.
//

import UIKit

class PendingMatchTableViewCell: UITableViewCell {

    @IBOutlet var gameLabel: UILabel!
    @IBOutlet var opponentLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    
    
    func updateViewsWith(_ pendingMatch: Match) {
        MatchController.shared.fetchGameAndOpponentFor(pendingMatch) { (game, opponent, success) in
            if success {
                DispatchQueue.main.async {
                    self.gameLabel.text = game?.name
                    self.opponentLabel.text = opponent?.username
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateStyle = .full
                    self.dateLabel.text = dateFormatter.string(from: pendingMatch.timestamp)
                    self.scoreLabel.text = "\(pendingMatch.winnerScore) - \(pendingMatch.loserScore)"
                }
            }
        }
    }
}
