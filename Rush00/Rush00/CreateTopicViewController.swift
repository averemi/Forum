//
//  CreateTopicViewController.swift
//  Rush00
//
//  Created by Anastasiia VEREMIICHYK on 4/7/19.
//  Copyright © 2019 Anastasiia VEREMIICHYK. All rights reserved.
//

import UIKit

class CreateTopicViewController: UIViewController {

    @IBOutlet weak var topicContentTextView: UITextView!
    @IBOutlet weak var topicNameTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func donePressed(_ sender: UIButton) {
        APIService.shared.createTopic(content: topicContentTextView.text, title: topicNameTextView.text, success: { (isSuccess) in
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }) { (error) in
            print(error)
        }
    }
    
}
