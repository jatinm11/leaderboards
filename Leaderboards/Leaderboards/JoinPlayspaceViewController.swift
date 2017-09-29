//
//  JoinPlayspaceViewController.swift
//  Leaderboards
//
//  Created by Jatin Menghani on 28/09/17.
//  Copyright © 2017 Jatin Menghani. All rights reserved.
//

import UIKit

class JoinPlayspaceViewController: UIViewController {
    
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var submitButton: UIButton!
    @IBOutlet var playspacejoinedMessage: UILabel!
    
    let colorProvider = BackgroundColorProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let randomColor = colorProvider.randomColor()
        self.view.backgroundColor = randomColor
        self.submitButton.tintColor = randomColor
        playspacejoinedMessage.isHidden = true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        passwordTextField.resignFirstResponder()
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        guard let password = passwordTextField.text else { return }
        PlayspaceController.shared.joinPlayspaceWith(password: password)
        playspacejoinedMessage.isHidden = false
        passwordTextField.resignFirstResponder()
    }
    
}
