//
//  UITableView+RegisterType.swift
//  AdX
//
//  Created by TELOLAHY Hugues Stéphano on 17/09/2022.
//
// swiftlint:disable force_cast

import UIKit

extension UITableView {
    
    func register<T: UITableViewCell>(cellType: T.Type) {
        register(T.self, forCellReuseIdentifier: T.className)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
        dequeueReusableCell(withIdentifier: T.className, for: indexPath) as! T
    }
}
