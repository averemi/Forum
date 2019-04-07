//
//  TopicsViewController.swift
//  Rush00
//
//  Created by Anastasiia VEREMIICHYK on 4/6/19.
//  Copyright © 2019 Anastasiia VEREMIICHYK. All rights reserved.
//

import UIKit

class TopicsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var topics: [Topics] = []
    var selectedTopic: Topics? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        
        getData()
        prepareUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func getData() {
        APIService.shared.getTopics(success: { (topicArray) in
            self.topics.removeAll()
            for element in topicArray {
                var topicArr = element as! [String: Any]
                let topic = Topics()
                
                if let authorDict = topicArr["author"] as? [String: Any] {
                    topic.author = authorDict["login"] as! String
                }
                if let messageDict = topicArr["message"] as? [String: Any] {
                    let contentDict = messageDict["content"] as! [String: Any]
                    topic.content = contentDict["markdown"] as! String
                }
                topic.title = topicArr["name"] as! String
                if let dateCreated = topicArr["created_at"] as? String {
                    topic.createdAt = dateCreated.components(separatedBy: "T").first!
                }
                if let messageUrlString = topicArr["messages_url"] as? String {
                    topic.messageUrlString = messageUrlString
                }
                if let id = topicArr["id"] as? Int {
                    topic.topicId = id
                }
                
                self.topics.append(topic)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }, failure: { error in
            print(error)
        })
    }
    
    func prepareUI() {
        self.navigationController?.navigationBar.isHidden = true
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120.0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToMessages" {
            guard let newViewController = segue.destination as? MessagesViewController else { return }
            
            newViewController.selectedTopic = selectedTopic
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "topicsTableViewCell") as! TopicsTableViewCell
        
        let topic = topics[indexPath.row]
        cell.configure(topic: topic)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedTopic = topics[indexPath.row]
        performSegue(withIdentifier: "goToMessages", sender: self)
    }
    
    
    @IBAction func logOut(_ sender: UIButton) {
        APIService.shared.isLoggedIn = false
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addTopicPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToAddTopic", sender: self)
    }
    
    
}

