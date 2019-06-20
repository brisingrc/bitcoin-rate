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
    let picker = UIPickerView()
    
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
        changeGraphPeriod.selectedSegmentIndex = 1
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
        rateDescriptionLabel.text = "Bitcoin to"
        pickCurrency.text = currentCode
        BpiDataService.getCurrentRate(currentCode: currentCode, completionHandler: { response in
            DispatchQueue.main.async {
                self.rateNumberLabel.text = response.rate
                self.rateCurrencyCodeLabel.text = response.code
                self.pickCurrency.resignFirstResponder()
            }
        })
        
    }
    
    //
    @objc func changeGraphSource(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            BpiDataService.getHistorical(start: Calendar.current.date(byAdding: .day, value: -7, to: Date()), end: Date(), currency: currentCode) { response in
                DispatchQueue.main.async {
                   self.drawGraph(response, "Average value by day")
                }
            }
        case 1:
            BpiDataService.getHistorical(start: Calendar.current.date(byAdding: .month, value: -1, to: Date()), end: Date(), currency: currentCode) { response in
                DispatchQueue.main.async {
                    self.drawGraph(response, "Average value by week")
                }
            }
        case 2:
            BpiDataService.getHistorical(start: Calendar.current.date(byAdding: .year, value: -1, to: Date()), end: Date(), currency: currentCode) { response in
                DispatchQueue.main.async {
                    self.drawGraph(response, "Average value by month")
                }
            }
        default:
            break
        }
        
       
        
    }
    private func drawGraph(_ values: [Double], _ title: String) {
        var lineChartEntry = [ChartDataEntry]()
        for i in 0...values.count - 1 {
            let value = ChartDataEntry(x: Double(i), y:values[i])
            lineChartEntry.append(value)
        }
        let line1 = LineChartDataSet(entries: lineChartEntry, label: title)
        line1.colors = [UIColor.blue]
        let data = LineChartData()
        data.addDataSet(line1)
        self.currencyChart.data = data
        self.currencyChart.chartDescription?.text = "My awesome chart"
    }
}
