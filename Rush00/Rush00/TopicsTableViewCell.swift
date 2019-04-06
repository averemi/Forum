//
//  TopicsTableViewCell.swift
//  Rush00
//
//  Created by Anastasiia VEREMIICHYK on 4/6/19.
//  Copyright © 2019 Anastasiia VEREMIICHYK. All rights reserved.
//

import UIKit

class TopicsTableViewCell: UITableViewCell {

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var topicLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    func configure(topic: Topics) {
        contentLabel.text = topic.content
        dateLabel.text = topic.createdAt
        topicLabel.text = topic.title
        authorLabel.text = topic.author
    }
}
