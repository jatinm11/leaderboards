
import UIKit

class PlayspacesViewController: UIViewController {
    
    let colorProvider = BackgroundColorProvider()
    
    var player: Player?
    
    @IBOutlet weak var playspaceButtonViewContainer: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addplayspaceButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
        
        let randomColor = colorProvider.randomColor()
        tableView.backgroundColor = randomColor
        view.backgroundColor = randomColor
        addplayspaceButton.tintColor = randomColor
        
        playspaceButtonViewContainer.layer.cornerRadius = 5
        playspaceButtonViewContainer.clipsToBounds = true
        
        navigationItem.setHidesBackButton(true, animated: false)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let currentPlayer = PlayerController.shared.currentPlayer {
            let playerImageButton = UIButton(type: .custom)
            playerImageButton.addTarget(self, action: #selector(playerImageButtonTapped), for: .touchUpInside)
            playerImageButton.setImage(currentPlayer.photo, for: .normal)
            playerImageButton.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
            playerImageButton.layer.cornerRadius = playerImageButton.frame.height / 2
            playerImageButton.clipsToBounds = true
            playerImageButton.layer.borderColor = UIColor.white.cgColor
            playerImageButton.layer.borderWidth = 2.0
            playerImageButton.addConstraint(NSLayoutConstraint(item: playerImageButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 32))
            playerImageButton.addConstraint(NSLayoutConstraint(item: playerImageButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 32))
            
            let pendingMatchesNotificationBadgeButton = UIButton(type: .system)
            pendingMatchesNotificationBadgeButton.addTarget(self, action: #selector(pendingMatchesNotificationBadgeButtonTapped), for: .touchUpInside)
            pendingMatchesNotificationBadgeButton.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
            pendingMatchesNotificationBadgeButton.backgroundColor = .white
            pendingMatchesNotificationBadgeButton.tintColor = view.backgroundColor
            pendingMatchesNotificationBadgeButton.layer.cornerRadius = pendingMatchesNotificationBadgeButton.frame.height / 2
            pendingMatchesNotificationBadgeButton.clipsToBounds = true
            pendingMatchesNotificationBadgeButton.layer.borderColor = UIColor.white.cgColor
            pendingMatchesNotificationBadgeButton.layer.borderWidth = 1.0
            
            PlayerController.shared.fetchPlayspacesFor(currentPlayer, completion: { (success) in
                if success {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        MatchController.shared.fetchPendingMatchesForCurrentPlayer(completion: { (success) in
                            if success {
                                DispatchQueue.main.async {
                                    if MatchController.shared.pendingMatches.count > 0 {
                                        pendingMatchesNotificationBadgeButton.setTitle("\(MatchController.shared.pendingMatches.count)", for: .normal)
                                        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: playerImageButton), UIBarButtonItem(customView: pendingMatchesNotificationBadgeButton)]
                                    } else {
                                        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: playerImageButton)]
                                    }
                                }
                            }
                        })
                    }
                }
            })
        }
    }
    
    
    @IBAction func addplayspaceButtonTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "Add Playspace", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Join Playspace", style: .default , handler: { (_) -> Void in
            let joinPlayspaceVC = UIStoryboard(name: "JoinPlayspace", bundle: nil).instantiateViewController(withIdentifier: "joinPlayspaceVC")
            self.present(joinPlayspaceVC, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "New Playspace", style: .default, handler: { (_) -> Void in
            let addPlayspaceVC = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "addPlayspaceVC")
            self.present(addPlayspaceVC, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func playerImageButtonTapped() {
        let currentPlayerProfileVC = UIStoryboard(name: "PlayerProfile", bundle: nil).instantiateViewController(withIdentifier: "currentPlayerProfileVC")
        present(currentPlayerProfileVC, animated: true, completion: nil)
    }
    
    @objc func pendingMatchesNotificationBadgeButtonTapped() {
        let pendingMatchesVC = UIStoryboard(name: "PlayerProfile", bundle: nil).instantiateViewController(withIdentifier: "pendingMatchesVC")
        present(pendingMatchesVC, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toGamesVC" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                let gamesVC = segue.destination as? GamesViewController else { return }
            title = "Playspaces"
            gamesVC.title = PlayspaceController.shared.playspaces[indexPath.row - 1].name
            PlayspaceController.shared.currentPlayspace = PlayspaceController.shared.playspaces[indexPath.row - 1]
        }
    }
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension PlayspacesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PlayspaceController.shared.playspaces.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "playspacesTitleCell", for: indexPath)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "playspaceCell", for: indexPath)
        cell.textLabel?.text = "\(PlayspaceController.shared.playspaces[indexPath.row - 1].name)"
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            navigationItem.title = nil
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            navigationItem.title = "Playspaces"
        }
    }
}
