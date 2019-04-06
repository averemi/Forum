//
//  MessagesViewController.swift
//  Rush00
//
//  Created by Anastasiia VEREMIICHYK on 4/6/19.
//  Copyright © 2019 Anastasiia VEREMIICHYK. All rights reserved.
//

import UIKit

class MessagesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var selectedTopic: Topics? = nil
    var messages: [Messages] = []
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getData()
        prepareUI()
    }
    
    func getData() {
        guard let topic = selectedTopic else { return }
        APIService.shared.getMessages(topicId: topic.topicId, success: { (messageArray) in
            self.messages.removeAll()
            for element in messageArray {
                var messageArr = element as! [String: Any]
                let message = Messages()

                if let authorDict = messageArr["author"] as? [String: Any] {
                    message.author = authorDict["login"] as! String
                }
                if let content = messageArr["content"] as? String {
                    message.content = content
                }
                self.messages.append(message)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
    func prepareUI() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120.0
        titleLabel.text = selectedTopic?.title
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messagesCell") as! MessageTableViewCell
        cell.configure(message: messages[indexPath.row])
 
        return cell
    }

}
