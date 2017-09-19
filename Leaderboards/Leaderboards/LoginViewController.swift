//
//  LoginViewController.swift
//  Leaderboards
//
//  Created by Mithun Reddy on 9/19/17.
//  Copyright © 2017 Jatin Menghani. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        guard let username = usernameTextField.text, !username.isEmpty else {
            self.presentSimpleAlert(title: "Unable to create an account", message: "Be sure you entered a valid email and username, and try again.")
            return
        }
        
        PlayerController.shared.createPlayerWith(username: username, photo: nil) { (success) in
            DispatchQueue.main.async {
                if !success {
                    self.presentSimpleAlert(title: "Unable to create an account", message: "Make sure you have a network connection, and please try again.")
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(segueToWelcomeVC), name: PlayerController.shared.currentPlayerWasSetNotification, object: nil)
    }
    
    func segueToWelcomeVC() {
        DispatchQueue.main.async {
            let welcomeVC = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "welcomeVC")
            self.navigationController?.pushViewController(welcomeVC, animated: true)
        }
    }
    
    func presentSimpleAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        alert.addAction(dismissAction)
        present(alert, animated: true, completion: nil)
    }

}
