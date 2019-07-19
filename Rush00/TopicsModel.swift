//
//  TopicsModel.swift
//  Rush00
//
//  Created by Anastasiia VEREMIICHYK on 4/6/19.
//  Copyright © 2019 Anastasiia VEREMIICHYK. All rights reserved.
//

class Topics {
    var author: String = ""
    var createdAt: String = ""
    var title: String = ""
    var content: String = ""
    var messageUrlString: String = ""
    var topicId: Int = 0
    
    init(author: String, createdAt: String, title: String, content: String, messageUrlString: String, topicId: Int) {
        self.author = author
        self.createdAt = createdAt
        self.title = title
        self.content = content
        self.messageUrlString = messageUrlString
        self.topicId = topicId
    }
    
    init() {
        
    }
}

