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
   
   static func getHistorical(start: Date?, end : Date?, currency: String, completionHandler: @escaping (Any) ->()) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "YYYY-MM-dd"
        
        guard let startDate = start, let endDate = end  else {return}
        var params:[String:String] = [:]
        params.updateValue(dateFormatter.string(from: startDate), forKey: "start")
        params.updateValue(dateFormatter.string(from: endDate), forKey: "end")
        params.updateValue(currency, forKey: "currency")
        
        guard let url = URL(string: "https://api.coindesk.com/v1/bpi/historical/close.json") else {return}
        NetworkService.shared.makeRequest(url: url, params: params) { (response) in
            completionHandler(response)
        }
        
    }
    
    static func getCurrentRate(currentCode: String, completionHandler: @escaping (Currency) -> ()) {
        guard let url = URL(string: "https://api.coindesk.com/v1/bpi/currentprice/\(currentCode).json") else {return}
        NetworkService.shared.makeRequest(url: url) { response in
            guard let response = response as? [String:Any] else {return}
            guard let currencyList = response["bpi"] as? [String:Any] else {return}
            let currentCurrency = ParseJson.findCurrencyByCode(currencyCode: currentCode, currencyList: currencyList)
            completionHandler(currentCurrency)
        }
   
    }
    
    func makeArrayForGraph(from: [Double]) {
        
    }
}
