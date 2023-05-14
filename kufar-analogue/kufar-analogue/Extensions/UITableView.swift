//
//  UITableView.swift
//  kufar-analogue
//
//  Created by Bahdan Piatrouski on 14.05.23.
//

import UIKit

extension UITableView {
    func register(_ cells: AnyClass...) {
        cells.forEach { cell in
            let id = String(describing: cell.self)
            let nib = UINib(nibName: id, bundle: nil)
            self.register(nib, forCellReuseIdentifier: id)
        }
    }
}
