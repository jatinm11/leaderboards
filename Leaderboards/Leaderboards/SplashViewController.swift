//
//  SplashViewController.swift
//  Leaderboards
//
//  Created by Mithun Reddy on 9/22/17.
//  Copyright © 2017 Jatin Menghani. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        PlayerController.shared.fetchCurrentPlayer { (success) in
            DispatchQueue.main.async {
                if success {
                    self.performSegue(withIdentifier: "toPlayspacesVC", sender: nil)
                    self.activityIndicator.stopAnimating()
                } else {
                    self.performSegue(withIdentifier: "toLoginVC", sender: nil)
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }

}
