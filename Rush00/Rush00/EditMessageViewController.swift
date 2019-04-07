//
//  EditMessageViewController.swift
//  Rush00
//
//  Created by Anastasiia VEREMIICHYK on 4/7/19.
//  Copyright © 2019 Anastasiia VEREMIICHYK. All rights reserved.
//

import UIKit

class EditMessageViewController: UIViewController {

    @IBOutlet weak var editMessageTextView: UITextView!
    var messageText = ""
    var messageId = 0

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        editMessageTextView.text = messageText
    }

    @IBAction func donePressed(_ sender: UIButton) {
        APIService.shared.updateMessage(editedMessage: editMessageTextView.text, messageId: messageId, success: { (isSuccess) in
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }) { (error) in
            print(error)
        }
    }
    
}
