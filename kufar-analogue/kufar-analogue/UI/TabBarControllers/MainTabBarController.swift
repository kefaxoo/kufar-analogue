//
//  MainTabBarController.swift
//  kufar-analogue
//
//  Created by Bahdan Piatrouski on 13.04.23.
//

import UIKit
import FirebaseAuth

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
    }
    
    private func configureTabBar() {
        let userVC = UserViewController(nibName: UserViewController.id, bundle: nil)
        userVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.fill"), tag: 1000)
        let addVC = AddViewController(nibName: AddViewController.id, bundle: nil)
        addVC.tabBarItem = UITabBarItem(title: "Add", image: UIImage(systemName: "plus.app.fill"), tag: 1001)
        self.viewControllers = [userVC.configureNavigationController(title: "Profile"), addVC.configureNavigationController(title: "Add post")]
        
        self.tabBar.tintColor = UIColor.systemPurple
    }
}
