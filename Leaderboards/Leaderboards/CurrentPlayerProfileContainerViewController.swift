//
//  CurrentPlayerProfileContainerViewController.swift
//  Leaderboards
//
//  Created by Mithun Reddy on 10/4/17.
//  Copyright © 2017 Jatin Menghani. All rights reserved.
//

import UIKit

class CurrentPlayerProfileContainerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var playerImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var statsMatchHistoryButtonContainer: UIView!
    @IBOutlet weak var statsMatchHistoryButton: UIButton!
    @IBOutlet weak var currentPlayerStatsContainer: UIView!
    @IBOutlet weak var currentPlayerMatchHistoryContainer: UIView!
    
    @IBAction func statsMatchHistoryButtonTapped(_ sender: Any) {
        if currentPlayerStatsContainer.alpha == 0 {
            currentPlayerStatsContainer.alpha = 1
            currentPlayerMatchHistoryContainer.alpha = 0
            statsMatchHistoryButton.setTitle("Match History", for: .normal)
        } else {
            currentPlayerStatsContainer.alpha = 0
            currentPlayerMatchHistoryContainer.alpha = 1
            statsMatchHistoryButton.setTitle("Stats", for: .normal)
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func playerImageViewTapped(_ sender: Any) {
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
    
    let colorProvider = BackgroundColorProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let currentPlayer = PlayerController.shared.currentPlayer else { return }
        playerImageView.image = currentPlayer.photo
        usernameLabel.text = currentPlayer.username
        
        playerImageView.layer.cornerRadius = playerImageView.frame.width / 2
        playerImageView.clipsToBounds = true
        playerImageView.layer.borderWidth = 3.0
        playerImageView.layer.borderColor = UIColor.white.cgColor
        
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        
        statsMatchHistoryButtonContainer.layer.cornerRadius = 5
        statsMatchHistoryButtonContainer.clipsToBounds = true
        
        let randomColor = colorProvider.randomColor()
        view.backgroundColor = randomColor
        statsMatchHistoryButton.tintColor = randomColor
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            let image = image
            PlayerController.shared.currentPlayer?.photo = image
            guard let currentPlayer = PlayerController.shared.currentPlayer else { return }
            PlayerController.shared.updatePlayer(currentPlayer, completion: { (success) in
                if success {
                    DispatchQueue.main.async {
                        picker.dismiss(animated: true, completion: nil)
                        self.playerImageView.image = image
                    }
                }
            })
        }
        
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
