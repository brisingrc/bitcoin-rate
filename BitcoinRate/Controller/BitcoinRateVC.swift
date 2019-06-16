//
//  BitcoinRateVC.swift
//  BitcoinRate
//
//  Created by Timur on 6/15/19.
//  Copyright © 2019 BitcoinRate. All rights reserved.
//

import UIKit
import Charts

class BitcoinRateVC: UIViewController {
    
    @IBOutlet weak var pickCurrency: UITextField!
    @IBOutlet weak var rateNumberLabel: UILabel!
    @IBOutlet weak var rateCurrencyCodeLabel: UILabel!
    @IBOutlet weak var rateDescriptionLabel: UILabel!
    @IBOutlet weak var currencyChart: LineChartView!
    @IBOutlet weak var changeGraphPeriod: UISegmentedControl!
    
    let currencyCodes = ["USD", "EUR", "KZT"]
    var currentCode = "USD"
//    var currentCurrency = ""
    let picker = UIPickerView()
//    var currencies = [[String:Currency]]()
    var currentCurrency = Currency()
    
    @objc func changeGraphSource(_ sender: UISegmentedControl) {
        let numbers:[Double] = [12,253,15,62,15,81,15]
        var lineChartEntry = [ChartDataEntry]()
        
        for i in 0...numbers.count - 1 {
            let value = ChartDataEntry(x: Double(i), y: numbers[i])
            lineChartEntry.append(value)
        }
        let line1 = LineChartDataSet(entries: lineChartEntry, label: "Number")
        line1.colors = [UIColor.blue]
        let data = LineChartData()
        data.addDataSet(line1)
        currencyChart.data = data
        currencyChart.chartDescription?.text = "My awesome chart"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeGraphPeriod.addTarget(self, action: #selector(changeGraphSource(_:)), for: .allEvents)
        updateUI()
        self.navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        picker.delegate = self
        picker.dataSource = self
        pickCurrency.inputView = picker
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red:0.11, green:0.60, blue:0.87, alpha:1.0)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Готово", style: .plain, target: self, action: #selector(updateUI))
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
       currentCode = currencyCodes[row]
    }
    

    @objc func closePickerView() {
        self.pickCurrency.resignFirstResponder()
    }
    
    //update UI elements depending of current currency code
    @objc func updateUI() {
        rateDescriptionLabel.text = "Bitcoin to \(currentCode)"
        guard let url = URL(string: "\(Constants.baseUrl)/currentprice/\(currentCode).json") else {return}
        NetworkService.shared.getData(url: url) { (response) in
            guard let currencyList = response["bpi"] as? [String:Any] else {return}
            self.currentCurrency = ParseJson.findCurrencyByCode(currencyCode: self.currentCode, currencyList: currencyList)
            
            DispatchQueue.main.async {
                self.rateNumberLabel.text = self.currentCurrency.rate
                self.rateCurrencyCodeLabel.text = self.currentCurrency.code
                self.pickCurrency.resignFirstResponder()
            }
            
            print(self.currentCurrency)
        }
    }
}
