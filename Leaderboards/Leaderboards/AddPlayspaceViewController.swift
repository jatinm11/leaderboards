//
//  AddPlayspaceViewController.swift
//  Leaderboards
//
//  Created by Jatin Menghani on 24/09/17.
//  Copyright © 2017 Jatin Menghani. All rights reserved.
//

import UIKit

class AddPlayspaceViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var playspaceTextField: UITextField!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    let colorProvider = BackgroundColorProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playspaceTextField.delegate = self
        
        let randomColor = colorProvider.randomColor()
        view.backgroundColor = randomColor
        
        
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.playspaceTextField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        playspaceTextField.resignFirstResponder()
    }
    
    
    // MARK :- Functions
    
    @IBAction func createButtonTapped(_ sender: Any) {
       
        guard let name = playspaceTextField.text, !name.isEmpty else { return }
        PlayspaceController.shared.createPlayspaceWith(name: name) { (password, success) in
            if success {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Password For Your New Playspace", message: password, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (_) in
                        self.dismiss(animated: true, completion: nil)
                    })
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
