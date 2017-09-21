//
//  PlayspacesViewController.swift
//  Leaderboards
//
//  Created by Mithun Reddy on 9/19/17.
//  Copyright © 2017 Jatin Menghani. All rights reserved.
//

import UIKit

class PlayspacesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addPlayspaceBarButtonItemTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Add New Playspace", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Enter Name"
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (_) in
            guard let name = alert.textFields?.first?.text, !name.isEmpty else { return }
            PlayspaceController.shared.createPlayspaceWith(name: name)
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func joinPlayspaceBarButtonItemTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Join Playspace", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Enter Password"
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Join", style: .default, handler: { (_) in
            guard let password = alert.textFields?.first?.text, !password.isEmpty else { return }
            PlayspaceController.shared.joinPlayspaceWith(password: password)
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let currentPlayer = PlayerController.shared.currentPlayer {
            PlayerController.shared.fetchPlayspacesFor(currentPlayer, completion: { (success) in
                if success {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            })
        }
    }
    
    
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension PlayspacesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PlayspaceController.shared.playspaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playspaceCell", for: indexPath)
        cell.textLabel?.text = PlayspaceController.shared.playspaces[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        PlayspaceController.shared.currentPlayspace = PlayspaceController.shared.playspaces[indexPath.row]
    }
    
}
