//
//  LoginViewController.swift
//  Leaderboards
//
//  Created by Mithun Reddy on 9/19/17.
//  Copyright © 2017 Jatin Menghani. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let colorProvider = BackgroundColorProvider()
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.attributedPlaceholder = NSAttributedString(string: "Enter Username",
                                                                     attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        let randomColor = colorProvider.randomColor()
        view.backgroundColor = randomColor
        
        navigationItem.setHidesBackButton(true, animated: false)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        usernameTextField.resignFirstResponder()
    }
    
    func presentSimpleAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        alert.addAction(dismissAction)
        present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toNewUserSelectImageVC" {
            guard let username = usernameTextField.text, !username.isEmpty else {
                self.presentSimpleAlert(title: "Unable to create an account", message: "Be sure you entered a valid username and try again.")
                return
            }
            
            let newUserSelectImageVC = segue.destination as? NewUserSelectImageViewController
            newUserSelectImageVC?.username = username
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.usernameTextField.resignFirstResponder()
        return true
    }
    
}
