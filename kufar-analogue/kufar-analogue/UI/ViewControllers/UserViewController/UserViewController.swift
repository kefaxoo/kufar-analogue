import UIKit
import FirebaseAuth
import SPIndicator
import FirebaseFirestore
import FirebaseStorage

class UserViewController: UIViewController {
    
    @IBOutlet weak var emptyProfileLabel: UILabel!
    @IBOutlet weak var postsTableView: UITableView!
    @IBOutlet weak var noPostLabel: UILabel!
    
    private var posts = [PostModel]()
    private var userType: UserType = .agent
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        setupLocalization()
        updateUserInfo()
        postsTableView.dataSource = self
        postsTableView.delegate = self
        postsTableView.register(PostTableViewCell.self)
        fetchPosts()
    }
    
    private func setupLocalization() {
        noPostLabel.text = Localization.Label.noAd.rawValue.localized
        emptyProfileLabel.text = Localization.Label.emptyProfile.rawValue.localized
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateUserInfo()
    }
    
    func set(_ type: UserType) {
        self.userType = type
    }
    
    private func configureNavBar() {
        if userType == .agent {
            self.navigationController?.navigationBar.tintColor = UIColor.systemPurple
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: Localization.NavigationBar.settings.rawValue.localized, style: .plain, target: self, action: #selector(openSettingsAction(_:)))
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: Localization.NavigationBar.signOut.rawValue.localized, style: .plain, target: self, action: #selector(openLoginAction(_:)))
        }
    }
    
    private func updateUserInfo() {
        if let user = Auth.auth().currentUser {
            emptyProfileLabel.isHidden = true
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: Localization.NavigationBar.signOut.rawValue.localized, style: .plain, target: self, action: #selector(signOutAccount(_:)))
            if let name = user.displayName {
                self.navigationItem.title = name
            } else {
                self.navigationItem.title = user.email
            }
        }
    }
    
    @objc private func openSettingsAction(_ sender: UIBarButtonItem) {
        let userSettingsVC = UserSettingsViewController(nibName: nil, bundle: nil)
        userSettingsVC.delegate = self
        userSettingsVC.navigationItem.title = Localization.Label.userSetting.rawValue.localized
        self.navigationController?.pushViewController(userSettingsVC, animated: true)
    }
    
    @objc private func openLoginAction(_ sender: UIBarButtonItem) {
        let signVC = SignViewController(nibName: SignViewController.id, bundle: nil)
        signVC.delegate = self
        let navSignVC = signVC.configureNavigationController()
        
        present(navSignVC, animated: true)
    }
    
    @objc private func signOutAccount(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            let signInVC = SignViewController(nibName: SignViewController.id, bundle: nil)
            signInVC.modalPresentationStyle = .fullScreen
            self.present(signInVC, animated: false)
        } catch let error as NSError {
            SPIndicator.present(title: Localization.Indicator.Title.error.rawValue.localized, message: error.localizedDescription, preset: .error, haptic: .error, from: .top)
        }
    }
    
    private func fetchPosts() {
        Firestore.firestore().collection("posts").getDocuments { [weak self] querySnapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                SPIndicator.present(title: Localization.Indicator.Title.error.rawValue.localized, message: error.localizedDescription, preset: .error, haptic: .error, from: .top)
            } else {
                if let user = Auth.auth().currentUser, let email = user.email {
                    querySnapshot?.documents.forEach { document in
                        guard let creatorEmail = document.data()["creatorEmail"] as? String else { return }
                        
                        if creatorEmail == email, let post = PostModel(JSON: document.data()) {
                            self.posts.append(post)
                        }
                    }
                } else {
                    querySnapshot?.documents.forEach { document in
                        if let post = PostModel(JSON: document.data()) {
                            self.posts.append(post)
                        }
                    }
                }
                
                self.postsTableView.reloadData()
                if self.posts.isEmpty {
                    self.noPostLabel.isHidden = false
                }
            }
        }
    }
}

extension UserViewController: ViewControllerDelegate {
    func refreshVC() {
        updateUserInfo()
    }
}

extension UserViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.id, for: indexPath)
        
        if let postCell = cell as? PostTableViewCell {
            postCell.set(posts[indexPath.row])
        }
        
        return cell
    }
}

extension UserViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? PostTableViewCell,
              let post = cell.post else { return }
        
        if userType == .agent {
            let editPostVC = AddViewController(nibName: AddViewController.id, bundle: nil)
            editPostVC.set(post)
            self.navigationController?.pushViewController(editPostVC, animated: true)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    
    
   
    
   // func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? PostTableViewCell,
              let post = cell.post else { return }
        
        if userType == .agent {
            let editPostVC = AddViewController(nibName: AddViewController.id, bundle: nil)
            editPostVC.set(post)
            self.navigationController?.pushViewController(editPostVC, animated: true)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let trash = UIContextualAction(style: .destructive,
                                       title: Localization.Button.Title.deleteAd.rawValue.localized) { [weak self] (action, view, completionHandler) in
            self?.handleMoveToTrash(indexPath: indexPath)
            completionHandler(true)
        }
        trash.backgroundColor = .systemRed
        
        let unread = UIContextualAction(style: .normal,
                                        title: Localization.ContextualAction.Title.edit.rawValue.localized) { [weak self] (action, view, completionHandler) in
            guard let cell = tableView.cellForRow(at: indexPath) as? PostTableViewCell,
                  let post = cell.post else {
                completionHandler(false)
                return
            }
            
            let editPostVC = AddViewController(nibName: AddViewController.id, bundle: nil)
            editPostVC.set(post)
            self?.navigationController?.pushViewController(editPostVC, animated: true)
            
            completionHandler(true)
        }
        
        unread.backgroundColor = .systemOrange
        
        let configuration = UISwipeActionsConfiguration(actions: [trash, unread])
      //  configuration.performsFirstActionWithFullSwipe = false
        
        return configuration
    }
    
    
    private func handleMarkAsUnread() {
        
    }
    
    private func handleMoveToTrash(indexPath: IndexPath) {
        self.posts.remove(at: indexPath.row)
        self.postsTableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView,
                   editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
}
