//
//  JoinPlayspaceViewController.swift
//  Leaderboards
//
//  Created by Jatin Menghani on 28/09/17.
//  Copyright © 2017 Jatin Menghani. All rights reserved.
//

import UIKit

class JoinPlayspaceViewController: UIViewController {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    let colorProvider = BackgroundColorProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let randomColor = colorProvider.randomColor()
        self.view.backgroundColor = randomColor
        
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        passwordTextField.resignFirstResponder()
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        guard let password = passwordTextField.text, !password.isEmpty else { return }
        PlayspaceController.shared.joinPlayspaceWith(password: password) { (success) in
            if success {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
}
