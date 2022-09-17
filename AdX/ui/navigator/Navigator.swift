//
//  Navigator.swift
//  AdX
//
//  Created by TELOLAHY Hugues Stéphano on 15/09/2022.
//

import UIKit

protocol NavigatorDependencies {
    func resolveDetailsViewController(_ ad: ClassifiedAd) -> DetailsViewController
    func resolveFilterViewController() -> FilterViewController
}

class Navigator: NavigatorProtocol {
    
    private weak var navController: UINavigationController?
    private let dependencies: NavigatorDependencies
    
    init(_ navController: UINavigationController, dependencies: NavigatorDependencies) {
        self.navController = navController
        self.dependencies = dependencies
    }
    
    func toDetails(_ ad: ClassifiedAd) {
        navController?.pushViewController(dependencies.resolveDetailsViewController(ad), animated: true)
    }
    
    func toFilter() {
        navController?.present(dependencies.resolveFilterViewController(), animated: true)
    }
}
