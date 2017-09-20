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
    @IBOutlet weak var playerImageView: UIImageView!
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        guard let username = usernameTextField.text, !username.isEmpty else {
            self.presentSimpleAlert(title: "Unable to create an account", message: "Be sure you entered a valid email and username, and try again.")
            return
        }
        
        PlayerController.shared.createPlayerWith(username: username, photo: playerImageView.image) { (success) in
            DispatchQueue.main.async {
                if !success {
                    self.presentSimpleAlert(title: "Unable to create an account", message: "Make sure you have a network connection, and please try again.")
                }
            }
        }
    }
    
    @IBAction func playerImageViewTapped(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let alert = UIAlertController(title: "Select Photo Location", message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (_) -> Void in
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            }))
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_) -> Void in
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            playerImageView.image = image
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(segueToPlayspacesViewController), name: PlayerController.shared.currentPlayerWasSetNotification, object: nil)
    }
    
    func segueToPlayspacesViewController() {
        DispatchQueue.main.async {
            let welcomeVC = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "playspacesViewController")
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
