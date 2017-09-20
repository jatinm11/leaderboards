//
//  JoinGameViewController.swift
//  Leaderboards
//
//  Created by Mithun Reddy on 9/20/17.
//  Copyright © 2017 Jatin Menghani. All rights reserved.
//

import UIKit

class JoinGameViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func cancelBarButtonItemTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func addGameBarButtonItemTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Add New Game", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Enter Name"
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (_) in
            guard let name = alert.textFields?.first?.text, !name.isEmpty else { return }
            GameController.shared.createGameWith(name: name, completion: { (success) in
                if success {
                    self.dismiss(animated: true, completion: nil)
                }
            })
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }

    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension JoinGameViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GameController.shared.gamesNotBelongingToCurrentPlayer.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath)
        cell.textLabel?.text = GameController.shared.gamesNotBelongingToCurrentPlayer[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let game = GameController.shared.gamesNotBelongingToCurrentPlayer[indexPath.row]
        GameController.shared.addCurrentPlayerToGame(game) { (success) in
            if success {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
}
