//
//  BitcoinRateVC.swift
//  BitcoinRate
//
//  Created by Timur on 6/15/19.
//  Copyright © 2019 BitcoinRate. All rights reserved.
//

import UIKit

class BitcoinRateVC: UIViewController {
    
    @IBOutlet weak var pickCurrency: UITextField!
    @IBOutlet weak var rateNumberLabel: UILabel!
    @IBOutlet weak var rateCurrencyCode: UILabel!
    
    let currencyCodes = ["USD", "EUR", "KZT"]
//    var currentCurrency = ""
    let picker = UIPickerView()
    var currencies = [Currency]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        picker.dataSource = self
        pickCurrency.inputView = picker
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red:0.11, green:0.60, blue:0.87, alpha:1.0)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Готово", style: .plain, target: self, action: #selector(closePickerView))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Отмена", style: .plain, target: self, action: #selector(closePickerView))
        toolBar.setItems([cancelButton,spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        pickCurrency.inputAccessoryView = toolBar
        
        
    }
    
}


extension BitcoinRateVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyCodes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyCodes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("pickerView delegate method was  called")
       updateUI(currencyCode: currencyCodes[row])
    }
    

    @objc func closePickerView() {
        self.view.endEditing(true)
    }
    
    func updateUI(currencyCode: String) {
        guard let url = URL(string: "\(Constants.baseUrl)/currentprice/\(currencyCode).json") else {return}
        NetworkService.shared.getData(url: url) { (response) in
            guard let currencyList = response["bpi"] as? [String:Any] else {return}
                print(currencyList.keys)
//            guard let usd = currencyList["USD"] as? [String:Any],
//                let secondCurrency = currencyList["\(currencyCode)"] as? [String:Any] else {return}
//            self.currencies.append(Currency(usd)!)
//            self.currencies.append(Currency(secondCurrency)!)
            
            
            print(self.currencies)
        }
    }
}
