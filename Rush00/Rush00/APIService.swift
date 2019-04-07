//
//  APIService.swift
//  Rush00
//
//  Created by Anastasiia VEREMIICHYK on 4/6/19.
//  Copyright © 2019 Anastasiia VEREMIICHYK. All rights reserved.
//

import UIKit

class APIService {
    var userCode: String = ""
    var accessToken: String = ""
    var userId: Int = 0
    var isLoggedIn = false
    
    func getAccessToken(success: ((Bool)->Void)?, failure: ((String)->Void)?) {
        
        let url = URL(string: "https://api.intra.42.fr/oauth/token?grant_type=authorization_code&client_id=\(ClientInfo.UID)&client_secret=\(ClientInfo.Secret)&code=\(self.userCode)&redirect_uri=\(ClientInfo.RedirectURI)")
        var request = URLRequest(url: url!)
        
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            if let error = error {
                failure?(error.localizedDescription)
            } else if let dt = data {
                do {
                    if let dictionary: NSDictionary = try JSONSerialization.jsonObject(with: dt, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        if let token = dictionary["access_token"] as? String {
                            self.accessToken = token
                            success?(true)
                        }
                    }
                } catch {
                    failure?(error.localizedDescription)
                }
            }
        }
        task.resume()
    }
    
    
    func getTopics(success: ((NSArray)->Void)?, failure: ((String)->Void)?) {
        let url = URL(string: "https://api.intra.42.fr/v2/topics?page[size]=100&sort=-created_at")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("Bearer \(self.accessToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            if let error = error {
                failure?(error.localizedDescription)
            } else if let dt = data {
                do {
                    if let topicArray: NSArray = try JSONSerialization.jsonObject(with: dt, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSArray {
                        success?(topicArray)
                    }
                } catch (let error) {
                    failure?(error.localizedDescription)
                }
            }
        }
        task.resume()
    }
    
    func getMessages(topicId: Int, success: ((NSArray)->Void)?, failure: ((String)->Void)?) {
        let url = URL(string: "https://api.intra.42.fr/v2/topics/\(topicId)/messages")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("Bearer \(self.accessToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            if let error = error {
                failure?(error.localizedDescription)
            } else if let dt = data {
                do {
                    if let topicArray: NSArray = try JSONSerialization.jsonObject(with: dt, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSArray {
                        success?(topicArray)
                    }
                } catch (let error) {
                    failure?(error.localizedDescription)
                }
            }
        }
        task.resume()
    }
    
    func getResponses(messageId: Int, success: ((NSArray)->Void)?, failure: ((String)->Void)?) {
        let url = URL(string: "https://api.intra.42.fr/v2/messages/\(messageId)/messages")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("Bearer \(self.accessToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            if let error = error {
                failure?(error.localizedDescription)
            } else if let dt = data {
                do {
                    if let topicArray: NSArray = try JSONSerialization.jsonObject(with: dt, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSArray {
                        success?(topicArray)
                    }
                } catch (let error) {
                    failure?(error.localizedDescription)
                }
            }
        }
        task.resume()
    }
    
    func createTopic(content: String, title: String, success: ((Bool)->Void)?, failure: ((String)->Void)?) {
        let url = URL(string: "https://api.intra.42.fr/v2/topics.json")
        let json = [
            "topic": [
                "author_id": "\(userId)",
                "cursus_ids": ["1"],
                "kind": "normal",
                "messages_attributes": [
                    [
                        "content": content,
                        ],
                ],
                "name": title,
                "tag_ids": ["574"],
            ],
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        var request = URLRequest(url: url!)
        
        request.httpMethod = "POST"
        request.setValue("Bearer \(self.accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            if let error = error {
                failure?(error.localizedDescription)
            } else if data != nil {
                success?(true)
            }
        }
        task.resume()
    }
    
    func getUserInfo(success: ((Bool)->Void)?, failure: ((String)->Void)?) {
        let url = URL(string: "https://api.intra.42.fr/v2/me")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            if let error = error {
                failure?(error.localizedDescription)
            } else if let dt = data {
                do {
                    if let dictionary: NSDictionary = try JSONSerialization.jsonObject(with: dt, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        self.userId = dictionary["id"] as! Int
                            success?(true)
                    }
                } catch (let error) {
                    failure?(error.localizedDescription)
                }
            }
        }
        task.resume()
    }
    
    func addMessage(message: String, topicId: Int, success: ((Bool)->Void)?, failure: ((String)->Void)?){
        let url = URL(string: "https://api.intra.42.fr/v2/topics/\(topicId)/messages")
        let json = [
            "message": [
                "author_id": "\(userId)",
                "content": message,
                "messageable_id": "\(topicId)",
                "messageable_type":"Topic",
            ],
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        var request = URLRequest(url: url!)
        
        request.httpMethod = "POST"
        request.setValue("Bearer \(self.accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = jsonData

        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            if let error = error {
                failure?(error.localizedDescription)
            } else if data != nil {
                success?(true)
            }
        }
        task.resume()
    }
    
    func deleteMessage(messageId: Int, success: ((Bool)->Void)?, failure: ((String)->Void)?) {
        let url = URL(string: "https://api.intra.42.fr/v2/messages/\(messageId)")
        var request = URLRequest(url: url!)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(self.accessToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            if let error = error {
                failure?(error.localizedDescription)
            } else if data != nil {
                success?(true)
            }
        }
        task.resume()
    }
    
    func deleteTopic(topicId: Int, success: ((Bool)->Void)?, failure: ((String)->Void)?) {
        let url = URL(string: "https://api.intra.42.fr/v2/topics/\(topicId).json")
        var request = URLRequest(url: url!)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(self.accessToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            if let error = error {
                failure?(error.localizedDescription)
            } else if data != nil {
                success?(true)
            }
        }
        task.resume()
    }
    
    func updateMessage(editedMessage: String, messageId: Int, success: ((Bool)->Void)?, failure: ((String)->Void)?) {
        let url = URL(string: "https://api.intra.42.fr/v2/messages/\(messageId)")
        let json = [
            "message": [
                "author_id": "\(userId)",
                "content": editedMessage,
                "messageable_id": "1",
                "messageable_type":"Topic",
            ],
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        var request = URLRequest(url: url!)
        request.httpMethod = "PUT"
        request.setValue("Bearer \(self.accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = jsonData
    
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            if let error = error {
                failure?(error.localizedDescription)
            } else if data != nil {
                print(editedMessage)
                print(response)
                success?(true)
            }
        }
        task.resume()
    }
}

extension APIService {
    static let shared = APIService()
}
