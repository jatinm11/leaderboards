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
    @IBOutlet weak var playerImageView: UIImageView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBAction func registerButtonTapped(_ sender: Any) {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerImageView.layer.cornerRadius = playerImageView.frame.width / 2
        playerImageView.layer.borderWidth = 3.0
        playerImageView.layer.borderColor = UIColor.white.cgColor
        playerImageView.clipsToBounds = true
        
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true

        usernameLabel.text = username

        let randomColor = colorProvider.randomColor()
        view.backgroundColor = randomColor

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
    }
}
