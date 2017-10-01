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
    
    let colorProvider = BackgroundColorProvider()
    
    @IBOutlet weak var currentPlayerImageView: UIImageView!
    @IBOutlet var tapOnimageLabel: UILabel!
    @IBOutlet weak var currentPlayerNameLabel: UILabel!
    @IBOutlet weak var opponentImageView: UIImageView!
    @IBOutlet weak var opponentNameLabel: UILabel!
    @IBOutlet weak var currentPlayerScoreTextField: UITextField!
    @IBOutlet weak var opponentScoreTextField: UITextField!
    @IBOutlet var currentPlayerTextFieldViewContainer: UIView!
    @IBOutlet var opponentPlayerTextFieldViewContainer: UIView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func submitButtonTapped(_ sender: Any) {
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
    
    @IBAction func opponentImageOrLabelTapped(_ sender: Any) {
        let selectOpponentVC = UIStoryboard(name: "Match", bundle: nil).instantiateViewController(withIdentifier: "selectOpponentVC") as? SelectOpponentViewController
        selectOpponentVC?.newMatchVC = self
        tapOnimageLabel.isHidden = true
        present(selectOpponentVC!, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        currentPlayerScoreTextField.resignFirstResponder()
        opponentScoreTextField.resignFirstResponder()
    }
    
    var opponent: Player?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let randomColor = colorProvider.randomColor()
        view.backgroundColor = randomColor
        
        currentPlayerImageView.layer.cornerRadius = currentPlayerImageView.frame.width / 2
        currentPlayerImageView.clipsToBounds = true
        currentPlayerImageView.layer.borderColor = UIColor.white.cgColor
        currentPlayerImageView.layer.borderWidth = 3.0
        opponentImageView.layer.cornerRadius = opponentImageView.frame.width / 2
        opponentImageView.clipsToBounds = true
        currentPlayerNameLabel.text = "You"
        currentPlayerImageView.image = PlayerController.shared.currentPlayer?.photo
        currentPlayerTextFieldViewContainer.layer.cornerRadius = 5
        opponentPlayerTextFieldViewContainer.layer.cornerRadius = 5
        
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let opponent = opponent {
            opponentNameLabel.text = opponent.username
            opponentImageView.image = opponent.photo
        }
        opponentImageView.layer.borderWidth = 3.0
        opponentImageView.layer.borderColor = UIColor.white.cgColor
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
