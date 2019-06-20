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
    static func getHistorical(start: Date?, end : Date?, currency: String, completionHandler: @escaping ([Double]) ->()) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "YYYY-MM-dd"
        
        guard let startDate = start, let endDate = end  else {return}
        var params:[String:String] = [:]
        params.updateValue(dateFormatter.string(from: startDate), forKey: "start")
        params.updateValue(dateFormatter.string(from: endDate), forKey: "end")
        params.updateValue(currency, forKey: "currency")
        
        guard let url = URL(string: "https://api.coindesk.com/v1/bpi/historical/close.json") else {return}
        NetworkService.shared.makeRequest(url: url, params: params) { (response) in
            guard let data = response as? JSON else {return}
            guard let bpi = data["bpi"] as? JSON else {return}
            print("bpi's count is \(bpi.count)")
            print(self.sort(bpi))
            completionHandler(self.sort(bpi))
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
    
    private static func sort(_ dic:JSON) -> [Double] {
        var rates: [Double] = []
        var tempItem: Double = 0
        if dic.count <= 7 {
            for value in dic.values {
                guard let value = value as? Double else {return rates}
                rates.append(value)
            }
        }
        else if dic.count > 7 && dic.count <= 31 {
            var tempArr = [Double]()
            for value in dic.values {
                guard let value = value as? Double else {return rates}
                tempArr.append(value)
            }
            let splitedTempArr = tempArr.chunked(into: 7)
            for array in splitedTempArr {
                rates.append(array.reduce(0, +))
            }
        }
        else {
            return rates
        }
        return rates
    }
}
