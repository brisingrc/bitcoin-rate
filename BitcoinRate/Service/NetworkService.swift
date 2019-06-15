//
//  NetworkService.swift
//  BitcoinRate
//
//  Created by Timur on 6/14/19.
//  Copyright © 2019 BitcoinRate. All rights reserved.
//

import Foundation

class NetworkService {
    private init() {}
    
    static let shared = NetworkService()
    
    func getData(url: URL, param: [String: String] = [:], completionHandler: @escaping ([String:Any]) -> ()) {
        let session = URLSession.shared
        
        var items = [URLQueryItem]()
        for (key,value) in param {
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
                
                completionHandler(json as! [String : Any])
            } catch {
                print(error)
            }
            }.resume()
    }
}
