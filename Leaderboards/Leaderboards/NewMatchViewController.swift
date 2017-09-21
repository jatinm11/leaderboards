//
//  NewMatchViewController.swift
//  Leaderboards
//
//  Created by Mithun Reddy on 9/20/17.
//  Copyright © 2017 Jatin Menghani. All rights reserved.
//

import UIKit
import CloudKit

class NewMatchViewController: UIViewController {
    
    @IBOutlet weak var currentPlayerImageView: UIImageView!
    @IBOutlet weak var currentPlayerNameLabel: UILabel!
    @IBOutlet weak var opponentImageView: UIImageView!
    @IBOutlet weak var opponentNameLabel: UILabel!
    @IBOutlet weak var currentPlayerScoreTextField: UITextField!
    @IBOutlet weak var opponentScoreTextField: UITextField!
    
    @IBAction func opponentImageOrLabelTapped(_ sender: Any) {
        let selectOpponentVC = UIStoryboard(name: "Match", bundle: nil).instantiateViewController(withIdentifier: "selectOpponentVC") as? SelectOpponentViewController
        selectOpponentVC?.newMatchVC = self
        present(selectOpponentVC!, animated: true, completion: nil)
    }
    
    @IBAction func submitMatchButtonTapped(_ sender: Any) {
        guard let currentPlayerScoreString = currentPlayerScoreTextField.text,
            !currentPlayerScoreString.isEmpty,
            let currentPlayerScore = Int(currentPlayerScoreString),
            let opponentScoreString = opponentScoreTextField.text,
            !opponentScoreString.isEmpty,
            let opponentScore = Int(opponentScoreString),
            let game = GameController.shared.currentGame,
            let currentPlayer = PlayerController.shared.currentPlayer,
            let opponent = opponent else { return }
        
        
        
        if currentPlayerScore > opponentScore {
            MatchController.shared.createMatch(game: game, winner: currentPlayer, winnerScore: currentPlayerScore, loser: opponent, loserScore: opponentScore, completion: { (success) in
                if success {
                    self.dismiss(animated: true, completion: nil)
                }
            })
        } else {
            MatchController.shared.createMatch(game: game, winner: opponent, winnerScore: opponentScore, loser: currentPlayer, loserScore: currentPlayerScore, completion: { (success) in
                if success {
                    self.dismiss(animated: true, completion: nil)
                }
            })
        }
        
    }
    
    
    var opponent: Player?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.currentPlayerNameLabel.text = PlayerController.shared.currentPlayer?.username
        self.currentPlayerImageView.image = PlayerController.shared.currentPlayer?.photo
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        opponentNameLabel.text = opponent?.username
        opponentImageView.image = opponent?.photo
    }
    
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    
}
