//
//  LoginViewController.swift
//  Leaderboards
//
//  Created by Mithun Reddy on 9/19/17.
//  Copyright © 2017 Jatin Menghani. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var createUsernameLabel: UILabel!
    @IBOutlet weak var createUsernameLabelCenterY: NSLayoutConstraint!
    
    //    var createUsernameLabel = UILabel()
    var labelHasMoved = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(segueToPlayspacesViewController), name: PlayerController.shared.currentPlayerWasSetNotification, object: nil)
        createUsernameLabel.alpha = 0.0
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if labelHasMoved == false {
            labelHasMoved = true
            createUsernameLabelCenterY.constant = createUsernameLabelCenterY.constant - usernameTextField.frame.height
            
            UIView.animate(withDuration: 0.5) {
                self.createUsernameLabel.frame = CGRect(x: self.usernameTextField.frame.origin.x, y: self.usernameTextField.frame.origin.y  - self.usernameTextField.frame.height, width: self.usernameTextField.frame.width, height: self.usernameTextField.frame.height)
                
                self.createUsernameLabel.alpha = 1.0
            }
        }
    }
}



extension UIImage {
    
    func resizeWithPercentage(percentage: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: size.width, height: size.height * percentage)))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    
    func resizeWithWidth(width: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
}













