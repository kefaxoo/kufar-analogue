//
//  UserViewController.swift
//  kufar-analogue
//
//  Created by Bahdan Piatrouski on 13.04.23.
//

import UIKit
import FirebaseAuth
import SPIndicator
import FirebaseFirestore

class UserViewController: UIViewController {

    @IBOutlet weak var emptyProfileLabel: UILabel!
    @IBOutlet weak var postsTableView: UITableView!
    @IBOutlet weak var noPostLabel: UILabel!
    
    private var posts = [PostModel]()
    private var userType: UserType = .agent
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        updateUserInfo()
        postsTableView.dataSource = self
        postsTableView.delegate = self
        postsTableView.register(PostTableViewCell.self)
        Firestore.firestore().collection("posts").getDocuments { querySnaphot, error in
            if error != nil {
                // MARK: -
                // TODO: Display indicator
            } else {
                if let user = Auth.auth().currentUser,
                   let email = user.email {
                    querySnaphot!.documents.forEach { document in
                        guard let creatorEmail = document.data()["creatorEmail"] as? String else { return }
                        
                        if creatorEmail == email {
                            guard let post = PostModel(JSON: document.data()) else { return }
                            
                            self.posts.append(post)
                        }
                    }
                } else {
                    querySnaphot!.documents.forEach { document in
                        guard let post = PostModel(JSON: document.data()) else { return }
                        
                        self.posts.append(post)
                    }
                }
                
                self.postsTableView.reloadData()
                if self.posts.isEmpty {
                    self.noPostLabel.isHidden = false
                }
            }
        }
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
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(openSettingsAction(_:)))
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign in", style: .plain, target: self, action: #selector(openLoginAction(_:)))
        }
    }
    
    private func updateUserInfo() {
        if let user = Auth.auth().currentUser {
            emptyProfileLabel.isHidden = true
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign out", style: .plain, target: self, action: #selector(signOutAccount(_:)))
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
        userSettingsVC.navigationItem.title = "User settings"
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
            SPIndicator.present(title: "Error", message: error.localizedDescription, preset: .error, haptic: .error, from: .top)
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
        guard let postCell = cell as? PostTableViewCell else { return cell }
        
        postCell.set(posts[indexPath.row])
        return postCell
    }
}

extension UserViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath),
              let postCell = cell as? PostTableViewCell,
              let post = postCell.post
        else { return }
    
        if userType == .agent {
            let editPostVC = AddViewController(nibName: AddViewController.id, bundle: nil)
            editPostVC.set(post)
            self.navigationController?.pushViewController(editPostVC, animated: true)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
