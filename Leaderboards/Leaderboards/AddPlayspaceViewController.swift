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
    
    var playspacePassword: String = ""
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPlayspaceCreatedVC" {
            if let destination = segue.destination as? PlayspaceCreatedAlertViewController {
                destination.password = playspacePassword
            }
        }
    }
    
    // MARK :- Functions
    
    @IBAction func createButtonTapped(_ sender: Any) {
       
        guard let name = playspaceTextField.text, !name.isEmpty else {
            let failedScreen = UIStoryboard(name: "playspaceFailed", bundle: nil).instantiateViewController(withIdentifier: "playspaceFailed")
            present(failedScreen, animated: true, completion: nil)
            return
        }
        PlayspaceController.shared.createPlayspaceWith(name: name) { (password, success) in
            if success {
                DispatchQueue.main.async {
                    guard let password = password else { return }
                    self.playspacePassword = password
                    self.performSegue(withIdentifier: "toPlayspaceCreatedVC", sender: nil)
                }
            }
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
