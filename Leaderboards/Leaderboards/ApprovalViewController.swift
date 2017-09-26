//
//  ApprovalViewController.swift
//  Leaderboards
//
//  Created by Jatin Menghani on 25/09/17.
//  Copyright © 2017 Jatin Menghani. All rights reserved.
//

import UIKit

class ApprovalViewController: UIViewController {

    var score: String = ""
    var game: String = ""
    var date: String = ""
    var opponent: String = ""
    
    @IBOutlet var playerImageView: UIImageView!
    @IBOutlet var detailViewContainer: UIView!
    @IBOutlet var aprooveButton: UIButton!
    @IBOutlet var declineButton: UIButton!
    @IBOutlet var opponentLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var gameLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.gameLabel.text = game
        self.scoreLabel.text = score
        self.dateLabel.text = date
        self.opponentLabel.text = opponent
        
        PlayerController.shared.fetchCurrentPlayer { (success) in
            if success {
                DispatchQueue.main.async {
                    //
                }
            }
        }
        
        detailViewContainer.layer.cornerRadius = 5
        detailViewContainer.clipsToBounds = true
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
}
