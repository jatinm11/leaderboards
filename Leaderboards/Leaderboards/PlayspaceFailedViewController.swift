//
//  PlayspaceFailedViewController.swift
//  Leaderboards
//
//  Created by Jatin Menghani on 02/10/17.
//  Copyright © 2017 Jatin Menghani. All rights reserved.
//

import UIKit

class PlayspaceFailedViewController: UIViewController {
    
    @IBOutlet var viewContainer: UIView!
    @IBOutlet var dismissButtonViewContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewContainer.layer.cornerRadius = 5
        viewContainer.clipsToBounds = true
        dismissButtonViewContainer.layer.cornerRadius = 5
        dismissButtonViewContainer.clipsToBounds = true
    }
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
