//
//  MainTabBarController.swift
//  kufar-analogue
//
//  Created by Bahdan Piatrouski on 13.04.23.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
    }
    
    private func configureTabBar() {
        let userVC = UserViewController(nibName: UserViewController.id, bundle: nil)
        userVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.fill"), tag: 1000)
        
        self.viewControllers = [userVC.configureNavigationController(title: "Profile")]
        self.tabBar.tintColor = UIColor.systemPurple
    }
    
}
