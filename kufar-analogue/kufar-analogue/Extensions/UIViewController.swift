//
//  UIViewController.swift
//  kufar-analogue
//
//  Created by Bahdan Piatrouski on 13.04.23.
//

import UIKit

extension UIViewController {
    func configureNavigationController(title: String? = nil) -> UINavigationController {
        if let title {
            self.navigationItem.title = title
        }
        
        let navController = UINavigationController(rootViewController: self)
        navController.navigationBar.prefersLargeTitles = true
        return navController
    }
    
    static var id: String {
        return String(describing: self.self)
    }
}
