//
//  NewGameViewController.swift
//  Leaderboards
//
//  Created by Jatin Menghani on 28/09/17.
//  Copyright © 2017 Jatin Menghani. All rights reserved.
//

import UIKit

class NewGameViewController: UIViewController {
    
    let colorProvider = BackgroundColorProvider()
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let randomColor = colorProvider.randomColor()
        view.backgroundColor = randomColor
        
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        nameTextField.resignFirstResponder()
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        guard let name = nameTextField.text, !name.isEmpty else { return }
        GameController.shared.createGameWith(name: name) { (success) in
            if success {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
}
