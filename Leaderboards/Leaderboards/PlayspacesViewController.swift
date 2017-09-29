
import UIKit

class PlayspacesViewController: UIViewController {
    
    let colorProvider = BackgroundColorProvider()
    
    var player: Player?
    
    @IBOutlet var playspaceButtonViewContainer: UIView!
    @IBOutlet var notificationbadgeView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var playerImage: UIImageView!
    @IBOutlet var notificationCountLabel: UILabel!
    @IBOutlet var addplayspaceButton: UIButton!
    
    @IBAction func addPlayspaceBarButtonItemTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Add New Playspace", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Enter Name"
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (_) in
            guard let name = alert.textFields?.first?.text, !name.isEmpty else { return }
            PlayspaceController.shared.createPlayspaceWith(name: name)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
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
        tableView.tableFooterView = UIView()
        let randomColor = colorProvider.randomColor()
        self.view.backgroundColor = randomColor
        self.tableView.backgroundColor = randomColor
        notificationCountLabel.tintColor = randomColor
        notificationCountLabel.textColor = randomColor
        addplayspaceButton.tintColor = randomColor
        playspaceButtonViewContainer.layer.cornerRadius = 5
        playspaceButtonViewContainer.clipsToBounds = true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let currentPlayer = PlayerController.shared.currentPlayer {
            PlayerController.shared.fetchPlayspacesFor(currentPlayer, completion: { (success) in
                if success {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        MatchController.shared.fetchPendingMatchesForCurrentPlayer(completion: { (success) in
                            if success {
                                DispatchQueue.main.async {
                                    self.notificationbadgeView.isHidden = true
                                    self.playerImage.image = currentPlayer.photo
                                    self.playerImage.layer.cornerRadius = self.playerImage.frame.height / 2
                                    self.playerImage.clipsToBounds = true
                                    self.playerImage.layer.borderColor = UIColor.white.cgColor
                                    self.playerImage.layer.borderWidth = 3.0
                                    if MatchController.shared.pendingMatches.count > 0 {
                                        self.notificationbadgeView.isHidden = false
                                        self.notificationCountLabel.text = "\(MatchController.shared.pendingMatches.count)"
                                        self.notificationbadgeView.layer.cornerRadius = self.notificationbadgeView.frame.width / 2
                                        self.notificationbadgeView.layer.borderColor = UIColor.white.cgColor
                                        self.notificationbadgeView.layer.borderWidth = 3.0
                                        self.notificationbadgeView.clipsToBounds = true
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toGamesVC" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            PlayspaceController.shared.currentPlayspace = PlayspaceController.shared.playspaces[indexPath.row]
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension PlayspacesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PlayspaceController.shared.playspaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playspaceCell", for: indexPath)
        cell.textLabel?.text = "\(PlayspaceController.shared.playspaces[indexPath.row].name)"
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
}
