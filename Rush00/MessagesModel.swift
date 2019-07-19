//
//  MessagesModel.swift
//  Rush00
//
//  Created by Anastasiia VEREMIICHYK on 4/6/19.
//  Copyright © 2019 Anastasiia VEREMIICHYK. All rights reserved.
//

class Messages {
    var author: String = ""
    var content: String = ""
    var id: Int = 0
    var date: String = ""
    
    init(author: String, content: String, id: Int, date: String) {
        self.author = author
        self.content = content
        self.id = id
        self.date = date
    }
    
    init() {
        
    }
}
