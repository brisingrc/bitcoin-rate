//
//  ParseJson.swift
//  BitcoinRate
//
//  Created by Тима Егембердиев on 6/16/19.
//  Copyright © 2019 BitcoinRate. All rights reserved.
//

import Foundation

class ParseJson {
    
    // find item with specified key in JSON
    static func findCurrencyByCode(currencyCode:String, currencyList: [String:Any]) -> Currency {
        if currencyList.keys.contains(currencyCode) {
            guard let currency = currencyList[currencyCode] as? [String:Any] else {return Currency()}
                return Currency(currency)
        }
        return Currency()
    }
}
