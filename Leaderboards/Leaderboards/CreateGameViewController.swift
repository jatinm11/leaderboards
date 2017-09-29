//
//  CreateGameViewController.swift
//  Leaderboards
//
//  Created by Jatin Menghani on 28/09/17.
//  Copyright © 2017 Jatin Menghani. All rights reserved.
//

import UIKit

class CreateGameViewController: UIViewController {

    let colorProvider = BackgroundColorProvider()
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var submitButton: UIButton!
    @IBOutlet var gameCreatedMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let randomColor = colorProvider.randomColor()
        self.view.backgroundColor = randomColor
        self.submitButton.tintColor = randomColor
        gameCreatedMessage.isHidden = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        nameTextField.resignFirstResponder()
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        guard let name = nameTextField.text else { return }
        GameController.shared.createGameWith(name: name)
        gameCreatedMessage.isHidden = false
        nameTextField.resignFirstResponder()
    }
}
