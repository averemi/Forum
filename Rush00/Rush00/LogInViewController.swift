//
//  LogInViewController.swift
//  Rush00
//
//  Created by Anastasiia VEREMIICHYK on 4/6/19.
//  Copyright © 2019 Anastasiia VEREMIICHYK. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLogInStatus()
        showAuthPage()
    }
    
    func showAuthPage() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        let url = URL(string: "https://api.intra.42.fr/oauth/authorize?client_id=\(ClientInfo.UID)&redirect_uri=rush00%3A%2F%2Faveremii_kkostrub&scope=public%20forum&response_type=code")
        let requestObj = URLRequest(url: url!)
        webView.loadRequest(requestObj)
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    func checkLogInStatus() {
        if !APIService.shared.isLoggedIn {
            let cookieJar = HTTPCookieStorage.shared
            
            for cookie in cookieJar.cookies! {
                cookieJar.deleteCookie(cookie)
            }
        }
    }
}
