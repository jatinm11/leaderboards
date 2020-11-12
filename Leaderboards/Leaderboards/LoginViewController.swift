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
    @IBOutlet weak var selectImageButton: UIButton!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var createButton: JAMButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.attributedPlaceholder = NSAttributedString(string: "Enter Username", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        usernameTextField.becomeFirstResponder()
        userImageView.layer.cornerRadius = 64
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
    
    
    @IBAction func selectImageButtonTapped(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let alert = UIAlertController(title: "Select Photo Location", message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (_) -> Void in
                imagePicker.sourceType = .photoLibrary
                imagePicker.allowsEditing = true
                imagePicker.navigationBar.tintColor = .black
                imagePicker.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
                self.present(imagePicker, animated: true, completion: nil)
            }))
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_) -> Void in
                imagePicker.sourceType = .camera
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func createButtonTapped(_ sender: Any) {
        print("Loading...")
        
        guard let username = self.usernameTextField.text else { return }
        PlayerController.shared.createPlayerWith(username: username, photo: self.userImageView.image) { (success, error) in
            DispatchQueue.main.async {
                if !success {
                    self.presentSimpleAlert(title: "Unable to create an account", message: error?.localizedDescription ?? "Make sure you have a network connection, and please try again.")
                } else {
                    let playspacesViewController = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "playspacesViewController")
                    playspacesViewController.modalPresentationStyle = .fullScreen
                    self.present(playspacesViewController, animated: true, completion: nil)
                }
            }
        }
    }
}

extension LoginViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.editedImage.rawValue)] as? UIImage {
            userImageView.image = image
        }
    }
}

extension LoginViewController {
    class func con() -> UIViewController {
        let vc = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "lginVC") as! LoginViewController
        return vc
    }
}
