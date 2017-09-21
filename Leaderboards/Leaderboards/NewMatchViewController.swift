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
    
    @IBAction func opponentImageOrLabelTapped(_ sender: Any) {
        let selectOpponentVC = UIStoryboard(name: "Match", bundle: nil).instantiateViewController(withIdentifier: "selectOpponentVC") as? SelectOpponentViewController
        selectOpponentVC?.newMatchVC = self
        present(selectOpponentVC!, animated: true, completion: nil)
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
