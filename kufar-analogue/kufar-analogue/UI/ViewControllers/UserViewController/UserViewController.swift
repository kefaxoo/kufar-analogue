//
//  UserViewController.swift
//  kufar-analogue
//
//  Created by Bahdan Piatrouski on 13.04.23.
//

import UIKit
import FirebaseAuth
import SPIndicator

class UserViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        updateUserInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateUserInfo()
    }
    
    private func configureNavBar() {
        self.navigationController?.navigationBar.tintColor = UIColor.systemPurple
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(openSettingsAction(_:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign in", style: .plain, target: self, action: #selector(openLoginAction(_:)))
    }
    
    private func updateUserInfo() {
        if let user = Auth.auth().currentUser {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign out", style: .plain, target: self, action: #selector(signOutAccount(_:)))
        }
    }
    
    @objc private func openSettingsAction(_ sender: UIBarButtonItem) {
        print("open settings")
    }
    
    @objc private func openLoginAction(_ sender: UIBarButtonItem) {
        let signVC = SignViewController(nibName: SignViewController.id, bundle: nil)
        let navSignVC = signVC.configureNavigationController()
        
        present(navSignVC, animated: true)
    }

    @objc private func signOutAccount(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            SPIndicator.present(title: "Success sign out", preset: .done, haptic: .success, from: .top)
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign in", style: .plain, target: self, action: #selector(openLoginAction(_:)))
        } catch let error as NSError {
            SPIndicator.present(title: "Error", message: error.localizedDescription, preset: .error, haptic: .error, from: .top)
        }
    }
    
}
