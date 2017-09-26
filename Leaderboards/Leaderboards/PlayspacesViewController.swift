
import UIKit

class PlayspacesViewController: UIViewController {
    
    let colorProvider = BackgroundColorProvider()
    
    var player: Player?

    @IBOutlet var joinPlayspaceButton: UIBarButtonItem!
    @IBOutlet var addPlayspaceButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var navigationBar: UINavigationBar!
    @IBOutlet var playerImage: UIImageView!
    
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
        self.joinPlayspaceButton.tintColor = randomColor
        self.addPlayspaceButton.tintColor = randomColor
        self.navigationBar.layer.cornerRadius = 5
        self.navigationBar.clipsToBounds = true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let currentPlayer = PlayerController.shared.currentPlayer {
            PlayerController.shared.fetchPlayspacesFor(currentPlayer, completion: { (success) in
                if success {
                    DispatchQueue.main.async {
                        self.playerImage.image = currentPlayer.photo
                        self.playerImage.layer.cornerRadius = self.playerImage.frame.height / 2
                        self.playerImage.clipsToBounds = true
                        self.playerImage.layer.borderColor = UIColor.white.cgColor
                        self.playerImage.layer.borderWidth = 3.0
                        self.tableView.reloadData()
                    }
                }
            })
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
        cell.textLabel?.text = ("\(indexPath.row + 1))  \(PlayspaceController.shared.playspaces[indexPath.row].name)")
        cell.detailTextLabel?.text = ">"
        cell.detailTextLabel?.textColor = UIColor.white
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        PlayspaceController.shared.currentPlayspace = PlayspaceController.shared.playspaces[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
}
