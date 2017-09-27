//
//  NewUserSelectImageViewController.swift
//  Leaderboards
//
//  Created by jonathan orellana on 9/20/17.
//  Copyright © 2017 Jatin Menghani. All rights reserved.
//

import UIKit

class NewUserSelectImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let colorProvider = BackgroundColorProvider()
    
    var username: String?
    @IBOutlet weak var skipButton: UIBarButtonItem!
    @IBOutlet var navigationBar: UINavigationBar!
    @IBOutlet weak var playerImageView: UIImageView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var backBarButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.playerImageView.layer.cornerRadius = playerImageView.frame.width / 2
        self.playerImageView.layer.borderWidth = 3.0
        self.playerImageView.layer.borderColor = UIColor.white.cgColor
        self.playerImageView.clipsToBounds = true
        self.navigationBar.clipsToBounds = true
        self.usernameLabel.text = username
        self.navigationBar.layer.cornerRadius = 5
        let randomColor = colorProvider.randomColor()
        self.skipButton.tintColor = randomColor
        self.view.backgroundColor = randomColor
        self.backBarButton.tintColor = randomColor
    }
    
    @IBAction func backBarButtonTapped(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func skipRegisterBarButtonTapped(_ sender: Any) {
        guard let username = username else { return }
        PlayerController.shared.createPlayerWith(username: username, photo: playerImageView.image) { (success) in
            DispatchQueue.main.async {
                if !success {
                    self.presentSimpleAlert(title: "Unable to create an account", message: "Make sure you have a network connection, and please try again.")
                } else {
                    let playspacesViewController = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "playspacesViewController")
                    self.present(playspacesViewController, animated: true, completion: nil)
                }
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    func presentSimpleAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        alert.addAction(dismissAction)
        present(alert, animated: true, completion: nil)
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
            playerImageView.image = image.resizeWithWidth(width: 700)!
        }
        skipButton = UIBarButtonItem(title: "Register", style: .done, target: self, action: #selector(skipRegisterBarButtonTapped))
    }
}
