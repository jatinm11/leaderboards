import UIKit

class JoinGameViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var cancelButton: UIBarButtonItem!
    @IBOutlet var navigationBar: UINavigationBar!
    
    let colorProvider = BackgroundColorProvider()
    
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
        let randomColor = colorProvider.randomColor()
        self.view.backgroundColor = randomColor
        self.cancelButton.tintColor = randomColor
        self.navigationBar.layer.cornerRadius = 5
        self.navigationBar.clipsToBounds = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = randomColor
        tableView.tableFooterView = UIView()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
}

extension JoinGameViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GameController.shared.gamesNotBelongingToCurrentPlayer.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath)
        cell.textLabel?.text = ("\(indexPath.row + 1)  \(GameController.shared.gamesNotBelongingToCurrentPlayer[indexPath.row].name)")
        cell.textLabel?.textColor = UIColor.white
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
}
