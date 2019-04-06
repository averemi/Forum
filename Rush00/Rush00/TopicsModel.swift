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
    
    init(author: String, createdAt: String, title: String, content: String) {
        self.author = author
        self.createdAt = createdAt
        self.title = title
        self.content = content
    }
    
    init() {
        
    }
}

