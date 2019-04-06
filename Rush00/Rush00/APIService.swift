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
    
    func getAccessToken(success: ((Bool)->Void)?) {
        
        let url = URL(string: "https://api.intra.42.fr/oauth/token?grant_type=authorization_code&client_id=\(ClientInfo.UID)&client_secret=\(ClientInfo.Secret)&code=\(self.userCode)&redirect_uri=\(ClientInfo.RedirectURI)")
        var request = URLRequest(url: url!)
        
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            if let err = error {
                print(err)
                //          success?(false)
            } else if let dt = data {
                do {
                    if let dictionary: NSDictionary = try JSONSerialization.jsonObject(with: dt, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        if let token = dictionary["access_token"] as? String {
                            self.accessToken = token
                            success?(true)
                        }
                    }
                } catch {
                    print(error)
                    //       success?(false)
                }
            }
        }
        task.resume()
    }
    
    
    func getTopics(success: ((NSArray)->Void)?) {
        let url = URL(string: "https://api.intra.42.fr/v2/topics?page[size]=100&sort=-created_at")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("Bearer \(self.accessToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            if let err = error {
                print(err)
            } else if let d = data {
                do {
                    if let topicArray: NSArray = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSArray {
                        success?(topicArray)
                    }
                } catch (let err) {
                    print(err)
                }
            }
        }
        task.resume()
    }
}

extension APIService {
    static let shared = APIService()
}
