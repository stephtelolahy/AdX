//
//  Navigator.swift
//  AdX
//
//  Created by TELOLAHY Hugues Stéphano on 15/09/2022.
//

import UIKit

protocol NavigatorDependencies {
    func resolveListViewController() -> ListViewController
    func resolveDetailsViewController(_ ad: ClassifiedAd) -> DetailsViewController
    func resolveFilterViewController(_ filters: [CategoryFilter], completion: (([CategoryFilter]) -> Void)?) -> FilterViewController
}

class Navigator: NavigatorProtocol {
    
    private weak var viewController: UIViewController?
    private let dependencies: NavigatorDependencies
    
    init(_ viewController: UIViewController, dependencies: NavigatorDependencies) {
        self.viewController = viewController
        self.dependencies = dependencies
    }
    
    func toDetails(_ ad: ClassifiedAd) {
        let vc = dependencies.resolveDetailsViewController(ad)
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func toFilter(_ filters: [CategoryFilter], completion: (([CategoryFilter]) -> Void)?) {
        let vc = dependencies.resolveFilterViewController(filters, completion: completion)
        if #available(iOS 15.0, *) {
            if let sheet = vc.sheetPresentationController {
                sheet.prefersGrabberVisible = true
            }
        }
        viewController?.present(vc, animated: true)
    }
    
    func dismiss() {
        viewController?.dismiss(animated: true)
    }
}
