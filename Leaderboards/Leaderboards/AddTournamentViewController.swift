//
//  AddTournamentViewController.swift
//  Leaderboards
//
//  Created by Mithun Reddy on 9/25/17.
//  Copyright © 2017 Jatin Menghani. All rights reserved.
//

import UIKit

class AddTournamentViewController: UIViewController {
    
    @IBOutlet weak var tournamentNameTextField: UITextField!
    
    @IBAction func createTournamentButtonTapped(_ sender: Any) {
        guard let name = tournamentNameTextField.text, !name.isEmpty else { return }
        TournamentController.shared.createTournamentWith(name: name) { (success) in
            if success {
                let startTournamentVC = UIStoryboard(name: "Tournament", bundle: nil).instantiateViewController(withIdentifier: "startTournamentVC") as? StartTournamentViewController
                self.present(startTournamentVC!, animated: true, completion: nil)
            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    

}
