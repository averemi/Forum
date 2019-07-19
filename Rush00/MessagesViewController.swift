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
    var selectedMessage: Messages? = nil
    var messages: [Messages] = []
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
        prepareUI()
    }
    
    func getData() {
        guard let topic = selectedTopic else { return }
        APIService.shared.getMessages(topicId: topic.topicId, success: { (messageArray) in
            self.messages.removeAll()
            print(messageArray)
            for element in messageArray {
                var messageArr = element as! [String: Any]
                let message = Messages()

                if let authorDict = messageArr["author"] as? [String: Any] {
                    message.author = authorDict["login"] as! String
                }
                if let content = messageArr["content"] as? String {
                    message.content = content
                }
                if let dateCreated = messageArr["created_at"] as? String {
                    message.date = dateCreated.components(separatedBy: "T").first!
                }
                if let id = messageArr["id"] as? Int {
                    message.id = id
                }
                self.messages.append(message)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }, failure: { error in
            print(error)
        })
    }
    
    func prepareUI() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120.0
        titleLabel.text = selectedTopic?.title
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToResponses" {
            guard let newViewController = segue.destination as? ResponseViewController else { return }
            
            newViewController.selectedMessage = selectedMessage
        }
        else if segue.identifier == "goToAddMessages" {
            guard let newViewController = segue.destination as? CreateMessageViewController else { return }
            
            newViewController.topicId = (selectedTopic?.topicId)!
        }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard indexPath.row != 0 else { return }

        selectedMessage = messages[indexPath.row]
        performSegue(withIdentifier: "goToResponses", sender: self)
        
    }
    
    @IBAction func addMessage(_ sender: UIButton) {
        performSegue(withIdentifier: "goToAddMessages", sender: self)
    }
    
    @IBAction func deleteTopic(_ sender: UIButton) {
        APIService.shared.deleteTopic(topicId: (selectedTopic?.topicId)!, success: { (isSuccess) in
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }) { (error) in
            print(error)
        }
    }
    
}
