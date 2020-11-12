//
//  WelcomeViewController.swift
//  Leaderboards
//
//  Created by Jatin Menghani on 13/11/20.
//  Copyright © 2020 Jatin Menghani. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var continueButton: JAMButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PlayerController.shared.checkIfLoggedInToiCloud { (status) in
            DispatchQueue.main.async {
                if status == .loggedIn {
                    self.messageLabel.text = "Click continue to start your battle."
                    self.continueButton.isEnabled = true
                }
                else {
                    self.messageLabel.text = "Looks like you are not logged in to your iCloud Account"
                    self.continueButton.isEnabled = false
                }
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        self.present(LoginViewController.con(), animated: true, completion: nil)
    }
}

extension WelcomeViewController {
    class func controller() -> UIViewController {
        let vc = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "welcomeVC") as! WelcomeViewController
        return vc
    }
}
