//
//  TransactionsTableViewController.swift
//  BitcoinRate
//
//  Created by Тима Егембердиев on 6/19/19.
//  Copyright © 2019 BitcoinRate. All rights reserved.
//

import UIKit

class TransactionsTableViewController: UITableViewController {
    
    
    var transactions = [Transaction]()
    let control = UIRefreshControl()
    var transaction: Transaction!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.refreshControl = control
        control.addTarget(self, action: #selector(getAllTransactions), for: .valueChanged)
        self.title = "Transactions list"
        showSpinner(onView: tableView)
        TransactionDataService.getAllTransactions { transactions in
            self.transactions = transactions
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.removeSpinner()
            }
        }
        
    }
    
    @objc func getAllTransactions() {
        TransactionDataService.getAllTransactions { transactions in
            self.transactions = transactions
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.removeSpinner()
                self.control.endRefreshing()
            }
        }
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return transactions.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TransactionTableViewCell
        cell.configure(transaction: transactions[indexPath.section])

        return cell
    }
   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        transaction = transactions[indexPath.section]
        performSegue(withIdentifier: "toTransationDetailVC", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! TransactionDetailViewController
        vc.transaction = transaction
    }
}

var vSpinner : UIView?
extension UITableViewController {
    
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }
}
