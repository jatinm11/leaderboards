//
//  StartTournamentViewController.swift
//  Leaderboards
//
//  Created by Mithun Reddy on 9/25/17.
//  Copyright © 2017 Jatin Menghani. All rights reserved.
//

import UIKit

class StartTournamentViewController: UIViewController {
    
    @IBAction func startTournamentButtonTapped(_ sender: Any) {
        TournamentController.shared.refreshCurrentTournament { (success) in
            if success {
                TournamentController.shared.startCurrentTournament(completion: { (success) in
                    if success {
                        let tournamentVC = UIStoryboard(name: "Tournament", bundle: nil).instantiateViewController(withIdentifier: "tournamentVC") as? TournamentViewController
                        self.present(tournamentVC!, animated: true, completion: nil)
                    }
                })
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
