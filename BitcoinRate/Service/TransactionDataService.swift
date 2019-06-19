//
//  TransactionDataService.swift
//  BitcoinRate
//
//  Created by Тима Егембердиев on 6/19/19.
//  Copyright © 2019 BitcoinRate. All rights reserved.
//

import Foundation

class TransactionDataService {

    static func getAllTransactions(completionHandler: @escaping([Transaction]) ->()) {
        guard let url = URL(string: "https://www.bitstamp.net/api/transactions") else {return}
            NetworkService.shared.makeRequest(url: url, completionHandler: { response in
                guard let data = response as? [[String:Any]] else {return}
                var transactions = [Transaction]()
                for item in data {
                    transactions.append(Transaction(item))
                }
                completionHandler(transactions)
            })
    }
}

