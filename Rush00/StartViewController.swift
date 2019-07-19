//
//  StartViewController.swift
//  Rush00
//
//  Created by Anastasiia VEREMIICHYK on 4/6/19.
//  Copyright © 2019 Anastasiia VEREMIICHYK. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    // MARK: Actions
    @IBAction func logInPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToLogIn", sender: self)
    }
    
    @IBAction func viewTopicsPressed(_ sender: UIButton) {
        APIService.shared.getAccessToken(success: { (isSuccess) in
            APIService.shared.getUserInfo(success: { (isSuccess) in
                print(APIService.shared.userId)
            }, failure:  { error in
                print(error)
            })
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "goToTopics", sender: self)
            }
        }, failure: { error in
            print(error)
        })
    }
}
