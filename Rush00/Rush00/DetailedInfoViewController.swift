//
//  DetailedInfoViewController.swift
//  Rush00
//
//  Created by Anastasiia VEREMIICHYK on 4/6/19.
//  Copyright © 2019 Anastasiia VEREMIICHYK. All rights reserved.
//

import UIKit

class DetailedInfoViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    var selectedTopic: Topics? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareUI()
    }
    
    func prepareUI() {
        titleLabel.text = selectedTopic?.title
        contentLabel.text = selectedTopic?.content
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToMessages" {
            guard let newViewController = segue.destination as? MessagesViewController else { return }
            
            newViewController.selectedTopic = selectedTopic
        }
    }

    @IBAction func goToMessages(_ sender: UIButton) {
        performSegue(withIdentifier: "goToMessages", sender: self)
    }



}
