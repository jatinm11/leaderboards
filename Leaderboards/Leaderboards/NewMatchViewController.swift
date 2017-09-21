//
//  NewMatchViewController.swift
//  Leaderboards
//
//  Created by Mithun Reddy on 9/20/17.
//  Copyright © 2017 Jatin Menghani. All rights reserved.
//

import UIKit

class NewMatchViewController: UIViewController {

    @IBOutlet weak var currentPlayerImageView: UIImageView!
    @IBOutlet weak var currentPlayerNameLabel: UILabel!
    @IBOutlet weak var opponentImageView: UIImageView!
    @IBOutlet weak var opponentNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        PlayerController.shared.fetchCurrentPlayer { (success) in
            if success {
                DispatchQueue.main.async {
                    self.currentPlayerNameLabel.text = PlayerController.shared.currentPlayer?.username
                    self.currentPlayerImageView.image = PlayerController.shared.currentPlayer?.photo
                }
            }
        }
        
    }

    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    }
    

}
