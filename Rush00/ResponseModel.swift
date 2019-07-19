//
//  ResponseModel.swift
//  Rush00
//
//  Created by Anastasiia VEREMIICHYK on 4/6/19.
//  Copyright © 2019 Anastasiia VEREMIICHYK. All rights reserved.
//

class Responses {
    var author: String = ""
    var content: String = ""
    var date: String = ""
    
    init(author: String, content: String, date: String) {
        self.author = author
        self.content = content
        self.date = date
    }
    
    init() {
        
    }
}
