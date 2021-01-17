//
//  LoginViewController.swift
//  Leaderboards
//
//  Created by Mithun Reddy on 9/19/17.
//  Copyright © 2017 Jatin Menghani. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    let colorProvider = BackgroundColorProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.attributedPlaceholder = NSAttributedString(string: "Enter Username",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
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
                self.presentSimpleAlert(title: "Unable to create an account", message: "Be sure you entered a valid username and try again."); return }
            
            let newUserSelectImageVC = segue.destination as? NewUserSelectImageViewController
            newUserSelectImageVC?.username = username
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.usernameTextField.resignFirstResponder()
        return true
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        
        if FileManager.default.ubiquityIdentityToken != nil {
            guard let username = usernameTextField.text, !username.isEmpty else {
                self.presentSimpleAlert(title: "Unable to create an account", message: "Be sure you entered a valid username and try again."); return }
            self.navigationController?.pushViewController(NewUserSelectImageViewController.controller(username: username), animated: true)
        }
        else {
            self.presentSimpleAlert(title: "Error.", message: "Seems like you're not logged in to your iCloud Account. Please login to continue.")
        }
    }
}
