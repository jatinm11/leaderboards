//
//  PlayspaceMembersListViewController.swift
//  Leaderboards
//
//  Created by Mithun Reddy on 10/5/17.
//  Copyright © 2017 Jatin Menghani. All rights reserved.
//

import UIKit

class PlayspaceMembersListViewController: UIViewController {
    
    var members: [Player]?
    let colorProvider = BackgroundColorProvider()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let randomColor = colorProvider.randomColor()
        view.backgroundColor = randomColor
        tableView.backgroundColor = randomColor
        
        tableView.delegate = self
        tableView.dataSource = self
        
        guard let currentPlayspace = PlayspaceController.shared.currentPlayspace else { return }
        
        title = currentPlayspace.name
        
        PlayerController.shared.fetchPlayersFor(currentPlayspace) { (members, success) in
            DispatchQueue.main.async {
                self.members = members
                self.tableView.reloadData()
            }
        }
    }

}

extension PlayspaceMembersListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let members = members else { return 0 }
        return members.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "memberTitleCell", for: indexPath)
            return cell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "memberCell", for: indexPath) as? PlayspaceMemberTableViewCell else { return PlayspaceMemberTableViewCell() }
        cell.updateViewWith(member: members?[indexPath.row - 1])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 44
        }
        return 80
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            title = PlayspaceController.shared.currentPlayspace?.name
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            title = "Members"
        }
    }
    
}
