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
    
    init(author: String, content: String) {
        self.author = author
        self.content = content
    }
    
    init() {
        
    }
}
