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
    var isLoggedIn = true // CHANGE TO FALSE
    
    ///// NOT FORGET TO CHANGE ISLOGGEDIN TO FALSE
    
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
                print(data)
                print(response)
                print(self.userId)
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
        // prepare json data
     //   let json = ["topic_id": "\(topicId)", "message": ["author_id":"\(userId)", "content":"Hello world", "messageable_id": "7", "messageable_type":"Topic"]]
        let json = [
            "topic": [
                "author_id": nil,
                "cursus_ids": ["1"],
                "kind": "normal",
                "messages_attributes": [
                    [
                        "content": message,
                        ],
                ],
                "name": "Hello",
                "tag_ids": ["574"],
            ],
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)

     //   let url = URL(string: "https://api.intra.42.fr/v2/topics/\(topicId)/messages")
         let url = URL(string: "https://api.intra.42.fr/v2/topics.json")
        var request = URLRequest(url: url!)
        
        request.httpMethod = "POST"
        request.setValue("Bearer \(self.accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // insert json data to the request
        request.httpBody = jsonData

        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            if let error = error {
                failure?(error.localizedDescription)
            } else if data != nil {
                print(data)
                print(response)
                print(self.userId)
                success?(true)
            }
        }
        task.resume()
    }
}

extension APIService {
    static let shared = APIService()
}
