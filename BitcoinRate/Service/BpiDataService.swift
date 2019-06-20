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
func sortByMonth() {
    var rateValues = [Double]()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    var arr = [[dateFormatter.date(from: "2019-06-12"):7238.341],[dateFormatter.date(from: "2019-05-13"):7300.4105],[dateFormatter.date(from: "2019-04-14"):7741.8847],[dateFormatter.date(from: "2019-04-15"):7887.3168],[dateFormatter.date(from: "2019-03-16"):8006.9002],[dateFormatter.date(from: "2019-02-17"):8323.638499999999],[dateFormatter.date(from: "2019-01-18"):8114.5371]]
    
    let calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
    var months = [Int]()
    
    for item in arr {
        guard case let date?? = item.keys.first else {return}
        let month = calendar.component(Calendar.Component.month, from: date)
        if !months.contains(month) {
            months.append(month)
        }
    }
    for i in months {
        let datesArray = arr.filter{ item -> Bool in
            guard case let date?? = item.keys.first else {return false}
            if calendar.component(Calendar.Component.month, from: date) == i {
                return true
            }
            return false
        }
        let newArr = datesArray.reduce(into: []) { rates, item in
            rat
        }
    }
}

sortByMonth()

