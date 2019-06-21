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
    
    static func sort(_ dic:JSON) -> [Double] {
        var rates: [Double] = []
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
            rates =  sortByMonth(dic: dic)
        }
        return rates
    }
}

func sortByMonth(dic: JSON) -> [Double] {
    
    var newDicArr: [[Date:Double]] = []
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    
    for (key, value) in dic {
        guard let date = formatter.date(from: key) else {return [Double]()}
        guard let value = value as? Double else {return [Double]()}
        newDicArr.append([date:value])
    }
    var rateValues = [Double]()
    
    let calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
    var months = [Int]()
    var years = [Int]()
    
    for item in newDicArr {
        guard let date = item.keys.first else {return[Double]()}
        let month = calendar.component(Calendar.Component.month, from: date)
        let year = calendar.component(Calendar.Component.year, from: date)
        
        if !months.contains(month) {
            months.append(month)
        }
        if !years.contains(year) {
            years.append(year)
        }
    }
    
    //    print(years)
    for j in years {
        for i in months {
            let datesArray = newDicArr.filter{ item -> Bool in
                guard let date = item.keys.first else {return false}
                if calendar.component(Calendar.Component.month, from: date) == i && calendar.component(Calendar.Component.year, from: date) == j {
                    return true
                }
                return false
            }
            let newArr = datesArray.reduce(into: [Double]()) { rates, item in
                rates.append(item.values.first!)
            }
            print(newArr)
            if newArr.isEmpty {
                continue
            }
            rateValues.append(getAverageValue(from: newArr))
            //            print(
        }
    }
    return rateValues
}

func getAverageValue(from: [Double]) -> Double {
    let sum = from.reduce(0.0) { sum, item  in
        sum + item
    }
    return sum/Double(from.count)
}



