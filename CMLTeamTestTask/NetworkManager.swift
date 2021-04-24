//
//  NetworkManager.swift
//  CMLTeamTestTask
//
//  Created by ALEXANDER on 4/22/21.
//  Copyright © 2021 ALEXANDER. All rights reserved.
//

import UIKit

class NetworkManager {
    
    // typical singleton access
    static let shared = NetworkManager()
    
    private var authHeader = "Authorization"
    
    // in larger app there probably could be some storage for a token
    // in the test app it's just private string in single network class
    private var tokenString: String = ""
    
    private let baseURLString = "https://re-next-qa.cmlteam.com"
    
    private let loginEndpoint = "auth/login"
    
    private let userEndpoint = "auth/current-user"
    
    private let listEndpoint = "/api/property/list"

    func authorise(credentials: Credentials, completion: @escaping (Error?) -> Void) {
        let url = URL.make(base: baseURLString, endpoint: loginEndpoint)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let jsonData = try? JSONEncoder().encode(credentials) else {
            completion(NSError(message: "Wrong credentials format"))
            return
        }
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
            // There and after, it's safer to run completion code on main thread, so from wherever we called network methods we shouldn't be worried about accidently touch UI from back threads. The code isn't time-consuming, so we don't slow the main thread.
            DispatchQueue.main.async {
                if let error = error {
                    completion(error)
                    return
                }
                guard let data = data else {
                    completion(NSError(message: "No data in response"))
                    return
                }
                guard let authToken = try? JSONDecoder().decode(AuthToken.self, from: data) else {
                    // if AuthToken is absent then error returned, so we can parse it and show to user
                    completion(NSError(errorData: data, defaultMessage: "No authToken"))
                    return
                }
                self.tokenString = authToken.tokenType + " " + authToken.accessToken
                completion(nil)
            }
        }
        task.resume()
    }
    
    func loadUser(completion: @escaping (User?, Error?) -> Void) {
        let url = URL.make(base: baseURLString, endpoint: userEndpoint)
        var request = URLRequest(url: url)
        request.addValue(tokenString, forHTTPHeaderField: authHeader)
        let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(nil, error)
                    return
                }
                guard let data = data else {
                    completion(nil, NSError(message: "No data in response"))
                    return
                }
                guard let user = try? JSONDecoder().decode(User.self, from: data) else {
                    // similar to token decoding
                    completion(nil, NSError(errorData: data, defaultMessage: "No user"))
                    return
                }
                completion(user, nil)
            }
        }
        task.resume()
    }
    
    func loadItems(accountID: Int, completion: @escaping ([Property]?, Error?) -> Void) {
        // Paging was not implemented, because there is no information about total page count, or remaining pages. Also, the test user has only 3 properties, which makes paging kinda stupid. Because of that, paging attributes are hardcoded.
        let page = 0
        let pageSize = 10
        let query = [
            "page": "\(page)",
            "pageSize": "\(pageSize)",
            "accountId": "\(accountID)"
        ]
        
        let url = URL.make(base: baseURLString, endpoint: listEndpoint, query: query)
        var request = URLRequest(url: url)
        request.addValue(tokenString, forHTTPHeaderField: authHeader)
        let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(nil, error)
                    return
                }
                guard let data = data else {
                    completion(nil, NSError(message: "No data in response"))
                    return
                }
                guard let propertiesContainer = try? JSONDecoder().decode(PropertyContainer.self, from: data) else {
                    // similar to token decoding
                    completion(nil, NSError(errorData: data, defaultMessage: "No properties"))
                    return
                }
                completion(propertiesContainer.data, nil)
            }
        }
        task.resume()
    }
    
    func loadImage(urlString: String, completion: @escaping (UIImage?, Error?) -> Void) {
        let url = URL(string: urlString)!
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(nil, error)
                    return
                }
                guard let data = data else {return}
                guard let image = UIImage(data: data) else {return}
                completion(image, nil)
            }
        }
        task.resume()
    }
}
