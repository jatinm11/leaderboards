//
//  SelectOpponentViewController.swift
//  Leaderboards
//
//  Created by Mithun Reddy on 9/20/17.
//  Copyright © 2017 Jatin Menghani. All rights reserved.
//

import UIKit

class SelectOpponentViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBAction func viewButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    weak var newMatchVC: NewMatchViewController?
    
    let colorProvider = BackgroundColorProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        let randomColor = colorProvider.randomColor()
        tableView.backgroundColor = randomColor
        tableView.tableFooterView = UIView()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        GameController.shared.fetchOpponentsForCurrentGame { (success) in
            if success {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
}

extension SelectOpponentViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PlayerController.shared.opponents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "opponentCell", for: indexPath)
        cell.textLabel?.text = PlayerController.shared.opponents[indexPath.row].username
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.textAlignment = .center
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        newMatchVC?.opponent = PlayerController.shared.opponents[indexPath.row]
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
