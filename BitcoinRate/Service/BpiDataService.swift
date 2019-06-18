//
//  NetworkService.swift
//  BitcoinRate
//
//  Created by Timur on 6/14/19.
//  Copyright © 2019 BitcoinRate. All rights reserved.
//

import Foundation

typealias JSON = [String:Any]

class BpiDataService {
    private init() {}
    
    static let shared = BpiDataService()
    
    private func makeRequest(url: URL, params: [String: String] = [:], completionHandler: @escaping (Any) -> ()) {
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
    
    func getHistorical(start: Date?, end : Date?, currency: String, completionHandler: @escaping (Any) ->()) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "YYYY-MM-dd"
        
        guard let startDate = start, let endDate = end  else {return}
        var params:[String:String] = [:]
        params.updateValue(dateFormatter.string(from: startDate), forKey: "start")
        params.updateValue(dateFormatter.string(from: endDate), forKey: "end")
        params.updateValue(currency, forKey: "currency")
        
        guard let url = URL(string: "\(Constants.baseUrl)/historical/close.json") else {return}
        BpiDataService.shared.makeRequest(url: url, params: params) { (response) in
            completionHandler(response)
        }
        
    }
    
    func getCurrentRate(currentCode: String, completionHandler: @escaping (Currency) -> ()) {
        guard let url = URL(string: "\(Constants.baseUrl)/currentprice/\(currentCode).json") else {return}
        BpiDataService.shared.makeRequest(url: url) { response in
            guard let response = response as? [String:Any] else {return}
            guard let currencyList = response["bpi"] as? [String:Any] else {return}
            let currentCurrency = ParseJson.findCurrencyByCode(currencyCode: currentCode, currencyList: currencyList)
            completionHandler(currentCurrency)
        }
   
    }
}
