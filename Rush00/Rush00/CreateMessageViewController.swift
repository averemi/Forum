//
//  CreateMessageViewController.swift
//  Rush00
//
//  Created by Anastasiia VEREMIICHYK on 4/7/19.
//  Copyright © 2019 Anastasiia VEREMIICHYK. All rights reserved.
//

import UIKit

class CreateMessageViewController: UIViewController {

    @IBOutlet weak var messageTextView: UITextView!
    var topicId: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func doneButtonPressed(_ sender: UIButton) {
        APIService.shared.addMessage(message: messageTextView.text, topicId: topicId, success: { (isSuccess) in
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }) { (error) in
            print(error)
        }
    }
    
}
