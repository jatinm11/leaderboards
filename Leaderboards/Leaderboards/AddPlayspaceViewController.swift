//
//  AddPlayspaceViewController.swift
//  Leaderboards
//
//  Created by Jatin Menghani on 24/09/17.
//  Copyright © 2017 Jatin Menghani. All rights reserved.
//

import UIKit

class AddPlayspaceViewController: UIViewController {

    @IBOutlet var playspaceCreatedLabel: UILabel!
    @IBOutlet var navigationBar: UINavigationBar!
    @IBOutlet var addPlayspaceButton: UIButton!
    @IBOutlet var passwordMessageLabel: UILabel!
    @IBOutlet var passwordLabel: UILabel!
    @IBOutlet var SavePasswordBarButton: UIBarButtonItem!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        playspaceCreatedLabel.isHidden = true
        passwordLabel.isHidden = true
        passwordLabel.isHidden = true
        passwordMessageLabel.isHidden = true
        SavePasswordBarButton.tintColor = UIColor.white
        navigationBar.layer.cornerRadius = 5
        navigationBar.clipsToBounds = true
    }

    @IBAction func addPlayspaceButtonTapped(_ sender: Any) {
        passwordMessageLabel.isHidden = false
        playspaceCreatedLabel.isHidden = false
        addPlayspaceButton.isHidden = true
        passwordLabel.isHidden = false
        passwordLabel.isHidden = false
        SavePasswordBarButton.tintColor = UIColor.red
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
}
