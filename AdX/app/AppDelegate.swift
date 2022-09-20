//
//  AppDelegate.swift
//  AdX
//
//  Created by TELOLAHY Hugues Stéphano on 14/09/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Root view controller
        let navController = UINavigationController()
        let navigator = Navigator(navController, dependencies: DIContainer.default)
        let rootVC = DIContainer.default.resolveListViewController(navigator: navigator)
        navController.setViewControllers([rootVC], animated: false)
        
        // Setup window
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = navController
        self.window?.makeKeyAndVisible()
        
        return true
    }
}
