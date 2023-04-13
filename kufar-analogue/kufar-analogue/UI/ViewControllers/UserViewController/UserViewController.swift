//
//  UserViewController.swift
//  kufar-analogue
//
//  Created by Bahdan Piatrouski on 13.04.23.
//

import UIKit

class UserViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
    }
    
    private func configureNavBar() {
        self.navigationController?.navigationBar.tintColor = UIColor.systemPurple
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(openSettingsAction(_:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign in", style: .plain, target: self, action: #selector(openLoginAction(_:)))
    }
    
    @objc private func openSettingsAction(_ sender: UIBarButtonItem) {
        print("open settings")
    }
    
    @objc private func openLoginAction(_ sender: UIBarButtonItem) {
        let signVC = SignViewController(nibName: SignViewController.id, bundle: nil)
        let navSignVC = signVC.configureNavigationController()
        
        present(navSignVC, animated: true)
    }

}
