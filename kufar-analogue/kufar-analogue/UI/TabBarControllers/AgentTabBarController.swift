//
//  AgentTabBarController.swift
//  kufar-analogue
//
//  Created by Bahdan Piatrouski on 13.04.23.
//

import UIKit
import FirebaseAuth

class AgentTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
    }
    
    private func configureTabBar() {
        let userVC = UserViewController(nibName: UserViewController.id, bundle: nil)
        userVC.tabBarItem = UITabBarItem(title: Localization.TabBar.profile.rawValue.localized, image: UIImage(systemName: "person.fill"), tag: 1000)
        let addVC = AddViewController(nibName: AddViewController.id, bundle: nil)
        addVC.tabBarItem = UITabBarItem(title: Localization.TabBar.add.rawValue.localized, image: UIImage(systemName: "plus.app.fill"), tag: 1001)
        self.viewControllers = [userVC.configureNavigationController(title: Localization.TabBar.profile.rawValue.localized), addVC.configureNavigationController(title: Localization.TabBar.add.rawValue.localized)]
        
        self.tabBar.tintColor = UIColor.systemPurple
    }
}
