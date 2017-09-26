//
//  AddPlayspaceViewController.swift
//  Leaderboards
//
//  Created by Jatin Menghani on 24/09/17.
//  Copyright © 2017 Jatin Menghani. All rights reserved.
//

import UIKit

class AddPlayspaceViewController: UIViewController, UITextFieldDelegate {
    
    // MARK :- OUTLETS
    @IBOutlet var playspaceTextField: UITextField!
    @IBOutlet var playspaceCreatedLabel: UILabel!
    @IBOutlet var navigationBar: UINavigationBar!
    @IBOutlet var passwordMessageLabel: UILabel!
    @IBOutlet var passwordLabel: UILabel!
    @IBOutlet var addPlacespaceBarButton: UIBarButtonItem!
    @IBOutlet var backBarButton: UIBarButtonItem!
    @IBOutlet var savePasswordButton: UIButton!
    @IBOutlet var buttonViewContainer: UIView!
    
    
    let colorProvider = BackgroundColorProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.playspaceTextField.delegate = self
        let randomColor = colorProvider.randomColor()
        self.view.backgroundColor = randomColor
        self.backBarButton.tintColor = randomColor
        self.addPlacespaceBarButton.tintColor = randomColor
        self.savePasswordButton.setTitleColor(randomColor, for: .normal)
        navigationBar.layer.cornerRadius = 5
        navigationBar.clipsToBounds = true
        buttonViewContainer.layer.cornerRadius = 5
        buttonViewContainer.clipsToBounds = true
        playspaceCreatedLabel.isHidden = true
        savePasswordButton.isHidden = true
        buttonViewContainer.isHidden = true
        passwordMessageLabel.isHidden = true
        passwordLabel.isHidden = true
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
    
    @IBAction func addPlayspaceButtonTapped(_ sender: Any) {
       
        guard let name = playspaceTextField.text, name != "" else { return }
        PlayspaceController.shared.createPlayspaceWith(name: name) { (password, success) in
            if success {
                DispatchQueue.main.async {
                    self.passwordLabel.text = password
                }
            }
            self.playspaceTextField.text = ""
        }
        playspaceCreatedLabel.isHidden = false
        savePasswordButton.isHidden = false
        passwordMessageLabel.isHidden = false
        passwordLabel.isHidden = false
        buttonViewContainer.isHidden = false
    }
    
    @IBAction func savePasswordButtonTapped(_ sender: Any) {
        
        let saveMessage = "My playspace password is \(self.passwordLabel.text!)"
        let ojectToSave = [saveMessage]
        let acitivityVC = UIActivityViewController(activityItems: ojectToSave, applicationActivities: nil)
        self.present(acitivityVC, animated: true, completion: nil)
        
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
