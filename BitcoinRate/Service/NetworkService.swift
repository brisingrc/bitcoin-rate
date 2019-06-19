//
//  NetworkService.swift
//  BitcoinRate
//
//  Created by Тима Егембердиев on 6/19/19.
//  Copyright © 2019 BitcoinRate. All rights reserved.
//

import Foundation

class NetworkService {
    private init(){}
    static let shared = NetworkService()
    
    func makeRequest(url: URL, params: [String: String] = [:], completionHandler: @escaping (Any) -> ()) {
        let session = URLSession.shared
        
        var items = [URLQueryItem]()
        for (key,value) in params {
            items.append(URLQueryItem(name: key, value: value))
        }
        
        var fullUrl = URLComponents(string: url.absoluteString)
        fullUrl?.queryItems = items
        
        var request = URLRequest(url: (fullUrl?.url)!)
        
        request.httpMethod = "GET"
        
        session.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                
                completionHandler(json)
            } catch {
                print(error)
            }
            }.resume()
    }
}
