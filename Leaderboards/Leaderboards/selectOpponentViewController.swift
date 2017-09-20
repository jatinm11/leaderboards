//
//  selectOpponentViewController.swift
//  Leaderboards
//
//  Created by Jatin Menghani on 20/09/17.
//  Copyright © 2017 Jatin Menghani. All rights reserved.
//

import UIKit

class selectOpponentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "opponentCell", for: indexPath)
        
        let player = PlayerController.shared.currentPlayer
        
        cell.textLabel?.text = player?.username
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }

}
