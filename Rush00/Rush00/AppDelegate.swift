//
//  AppDelegate.swift
//  Rush00
//
//  Created by Anastasiia VEREMIICHYK on 4/6/19.
//  Copyright © 2019 Anastasiia VEREMIICHYK. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        print("Redirect url: \(url)")
        
        if (url.scheme == "rush00") {
            
            if let userCode = url.absoluteString.components(separatedBy: "=").last {
                APIService.shared.userCode = userCode
                if let vc = self.window?.rootViewController as? UINavigationController {
                    APIService.shared.isLoggedIn = true
                    vc.popViewController(animated: true)
                }
            }
        }
        return true
    }
}
