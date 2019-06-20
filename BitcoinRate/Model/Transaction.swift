//
//  Transaction.swift
//  BitcoinRate
//
//  Created by Тима Егембердиев on 6/19/19.
//  Copyright © 2019 BitcoinRate. All rights reserved.
//

import Foundation

struct Transaction {
    let tid: Int
    let transactionType: Int
    let date: String
    let price: String
    let amount: String
    
    init(_ dic:[String:Any])  {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd-hh:mm:ss"
        
        self.tid = dic["tid"] as? Int ?? 0
        self.transactionType = dic["type"] as? Int ?? 0
        self.price = dic["price"] as? String ?? "Not defined"
        self.date = formatter.string(from: Date(timeIntervalSince1970: Double(dic["date"] as? String ?? "0")!))
        self.amount = dic["amount"] as? String ?? "Not defined"
    }
    

}


