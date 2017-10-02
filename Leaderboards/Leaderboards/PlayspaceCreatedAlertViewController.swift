//
//  PlayspaceCreatedAlertViewController.swift
//  Leaderboards
//
//  Created by Jatin Menghani on 02/10/17.
//  Copyright © 2017 Jatin Menghani. All rights reserved.
//

import UIKit

class PlayspaceCreatedAlertViewController: UIViewController {
    
    @IBOutlet var dismissButtonViewContainer: UIView!
    @IBOutlet var savePasswordButtonContainer: UIView!
    @IBOutlet var passwordMessage: UILabel!
    @IBOutlet var messageViewContainer: UIView!
    
    var password: String = ""
    var playspaceName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.messageViewContainer.layer.cornerRadius = 5
        self.messageViewContainer.clipsToBounds = true
        self.savePasswordButtonContainer.layer.cornerRadius = 5
        self.savePasswordButtonContainer.clipsToBounds = true
        self.dismissButtonViewContainer.layer.cornerRadius = 5
        self.dismissButtonViewContainer.clipsToBounds = true
        passwordMessage.text = "Your password is: \(password)"
    }

    
    @IBAction func savePasswordButtonTapped(_ sender: Any) {
        let textToShare = "My playspace \(self.playspaceName)'s password is: \(self.password)"
        let share = [textToShare]
        let activityVC = UIActivityViewController(activityItems: share, applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
        
    }
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        guard let addPlayspaceVC = presentingViewController else { return }
        dismiss(animated: true) {
            addPlayspaceVC.dismiss(animated: true, completion: nil)
        }
    }
}
