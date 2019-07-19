//
//  ResponseViewController.swift
//  Rush00
//
//  Created by Anastasiia VEREMIICHYK on 4/6/19.
//  Copyright © 2019 Anastasiia VEREMIICHYK. All rights reserved.
//

import UIKit

class ResponseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var selectedMessage: Messages? = nil
    var responses: [Responses] = []

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
        prepareUI()
    }
    
    func getData() {
        guard let message = selectedMessage else { return }
        APIService.shared.getResponses(messageId: message.id, success: { (responseArray) in
            self.responses.removeAll()
            for element in responseArray {
                var responseArr = element as! [String: Any]
                let response = Responses()
              
                if let authorDict = responseArr["author"] as? [String: Any] {
                   response.author = authorDict["login"] as! String
                }
                if let dateCreated = responseArr["created_at"] as? String {
                    response.date = dateCreated.components(separatedBy: "T").first!
                }
                if let content = responseArr["content"] as? String {
                    response.content = content
                }
                self.responses.append(response)
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
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToEditMessage" {
            guard let newViewController = segue.destination as? EditMessageViewController else { return }
            
            newViewController.messageText = (selectedMessage?.content)!
            newViewController.messageId = (selectedMessage?.id)!
        }
    }
    
    @IBAction func deleteMessageTapped(_ sender: UIButton) {
        APIService.shared.deleteMessage(messageId: (selectedMessage?.id)!, success: { (isSuccess) in
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }) { (error) in
            print(error)
        }
    }
    
    @IBAction func updateMessageTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "goToEditMessage", sender: self)
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return responses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "responsesCell") as! ResponseTableViewCell
        print(cell.configure(response: responses[indexPath.row]))
        cell.configure(response: responses[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

