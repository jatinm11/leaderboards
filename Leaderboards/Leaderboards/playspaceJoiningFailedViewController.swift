//
//  playspaceJoiningFailedViewController.swift
//  Leaderboards
//
//  Created by Jatin Menghani on 04/10/17.
//  Copyright © 2017 Jatin Menghani. All rights reserved.
//

import UIKit

class playspaceJoiningFailedViewController: UIViewController {
    
    @IBOutlet var viewContainer: UIView!
    @IBOutlet var buttonViewContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.buttonViewContainer.layer.cornerRadius = 5
        self.viewContainer.layer.cornerRadius = 5
        self.viewContainer.clipsToBounds = true
    }
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
