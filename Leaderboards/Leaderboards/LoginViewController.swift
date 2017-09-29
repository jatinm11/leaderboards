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
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var createUserNameCenterYConstraint: NSLayoutConstraint!
    
    var labelHasMoved = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.delegate = self
        usernameTextField.attributedPlaceholder = NSAttributedString(string: "Enter Username",
                                                                     attributes: [NSForegroundColorAttributeName: UIColor.white])
        
        createUsernameLabel.alpha = 0.0
        
        let randomColor = colorProvider.randomColor()
        view.backgroundColor = randomColor

        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        usernameTextField.resignFirstResponder()
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
