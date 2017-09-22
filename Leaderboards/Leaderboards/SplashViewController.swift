//
//  SplashViewController.swift
//  Leaderboards
//
//  Created by Mithun Reddy on 9/22/17.
//  Copyright © 2017 Jatin Menghani. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        PlayerController.shared.fetchCurrentPlayer { (success) in
            DispatchQueue.main.async {
                if success {
                    self.performSegue(withIdentifier: "toPlayspacesVC", sender: nil)
                } else {
                    self.performSegue(withIdentifier: "toLoginVC", sender: nil)
                }
            }
        }
    }

}
