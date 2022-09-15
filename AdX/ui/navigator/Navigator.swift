//
//  Navigator.swift
//  AdX
//
//  Created by TELOLAHY Hugues Stéphano on 15/09/2022.
//

import UIKit

protocol NavigatorDependencies {
    func resolveAdDetailsViewController(_ ad: ClassifiedAd) -> AdDetailsViewController
}

class Navigator: NavigatorProtocol {
    
    private weak var navController: UINavigationController?
    private let dependencies: NavigatorDependencies
    
    init(_ navController: UINavigationController, dependencies: NavigatorDependencies) {
        self.navController = navController
        self.dependencies = dependencies
    }
    
    func toAdDetails(_ ad: ClassifiedAd) {
        navController?.pushViewController(dependencies.resolveAdDetailsViewController(ad), animated: true)
    }
}
