//
//  TransactionDetailViewController.swift
//  BitcoinRate
//
//  Created by Timur on 6/20/19.
//  Copyright © 2019 BitcoinRate. All rights reserved.
//

import UIKit

class TransactionDetailViewController: UIViewController {

    var transaction: Transaction!
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure(transaction: transaction)
       
    }
    

    func configure(transaction: Transaction) {
        self.idLabel.text = String(transaction.tid)
        self.amountLabel.text = transaction.amount
        self.rateLabel.text = transaction.price
        self.dateLabel.text = transaction.date
    }

}
