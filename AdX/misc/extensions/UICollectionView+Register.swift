//
//  UICollectionView+Register.swift
//  AdX
//
//  Created by TELOLAHY Hugues Stéphano on 14/09/2022.
//
// swiftlint:disable force_cast

import UIKit

extension UICollectionView {
    
    func register<T: UICollectionViewCell>(cellType: T.Type) {
        register(T.self, forCellWithReuseIdentifier: cellType.className)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
        dequeueReusableCell(withReuseIdentifier: type.className, for: indexPath) as! T
    }
}
