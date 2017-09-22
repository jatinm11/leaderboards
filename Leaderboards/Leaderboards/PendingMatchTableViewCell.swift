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
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var opponentLabel: UILabel!
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
                    
                    self.scoreLabel.text = "\(pendingMatch.winnerScore) - \(pendingMatch.loserScore)"
                }
            }
        }
    }

}
