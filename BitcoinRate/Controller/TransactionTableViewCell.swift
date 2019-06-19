//
//  TransactionTableViewCell.swift
//  BitcoinRate
//
//  Created by Тима Егембердиев on 6/19/19.
//  Copyright © 2019 BitcoinRate. All rights reserved.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {

    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    func configure(transaction: Transaction) {
        self.amountLabel.text = transaction.amount
        switch transaction.transactionType {
        case 0:
            self.typeLabel.text = "Buy"
        default:
            self.typeLabel.text = "Sell"
        }
        self.dateLabel.text = transaction.date
        
    }

}
