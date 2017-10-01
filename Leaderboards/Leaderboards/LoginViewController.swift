//
//  LoginViewController.swift
//  Leaderboards
//
//  Created by Mithun Reddy on 9/19/17.
//  Copyright © 2017 Jatin Menghani. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    let colorProvider = BackgroundColorProvider()
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var createUsernameLabel: UILabel!
    @IBOutlet weak var createUserNameCenterYConstraint: NSLayoutConstraint!
    
    var labelHasMoved = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.delegate = self
        usernameTextField.attributedPlaceholder = NSAttributedString(string: "Enter Username",
                                                                     attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        createUsernameLabel.alpha = 0.0
        
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
    
    
    
    // MARK: - UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, text.isEmpty {
            if labelHasMoved == false {
                labelHasMoved = true
                UIView.animate(withDuration: 0.3) {
                    self.createUserNameCenterYConstraint.constant = -30
                    self.createUsernameLabel.alpha = 1.0
                }
            }
        } else if let text = textField.text, text.characters.count == 1, string == "" {
            labelHasMoved = false
            UIView.animate(withDuration: 0.3) {
                self.createUsernameLabel.frame = CGRect(x: self.usernameTextField.frame.origin.x, y: self.usernameTextField.frame.origin.y, width: self.usernameTextField.frame.width, height: self.usernameTextField.frame.height)
                self.createUsernameLabel.alpha = 0.0
            }
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.usernameTextField.resignFirstResponder()
        return true
    }
    
}
