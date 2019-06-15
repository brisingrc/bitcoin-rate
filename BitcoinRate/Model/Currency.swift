//
//  Currency.swift
//  BitcoinRate
//
//  Created by Timur on 6/14/19.
//  Copyright © 2019 BitcoinRate. All rights reserved.
//

import Foundation

struct Currency {
    let code: String
    let rate: String
    let description: String
    let rate_float: Double
    
    init?(_ dic: [String:Any]) {
        guard let code = dic["code"] as? String,
            let rate = dic["rate"] as? String,
            let description = dic["description"] as? String,
            let rate_float = dic["rate_float"] as? Double else {return nil}
        self.code = code
        self.rate = rate
        self.description = description
        self.rate_float = rate_float
    }
    
    init() {
        self.code = ""
        self.rate = ""
        self.description = ""
        self.rate_float = 0
    }
}
