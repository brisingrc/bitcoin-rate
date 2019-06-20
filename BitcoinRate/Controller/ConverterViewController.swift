//
//  ConverterViewController.swift
//  BitcoinRate
//
//  Created by Timur on 6/20/19.
//  Copyright © 2019 BitcoinRate. All rights reserved.
//

import UIKit

class ConverterViewController: UIViewController {
   
    

    let currencyCodes = ["USD", "EUR", "KZT"]
    var currentCode = "USD"
    let picker = UIPickerView()
    
    @IBOutlet weak var amountTF: UITextField!
    @IBOutlet weak var pickCurrency: UITextField!
    @IBOutlet weak var convertBtn: UIButton!
    @IBOutlet weak var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        convertBtn.layer.cornerRadius = 5
        convertBtn.backgroundColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        convertBtn.layer.borderColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
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
        updateUI()
    }
    
    @IBAction func updateUI() {
        print("updateUI method was called")
        pickCurrency.text = currentCode
        BpiDataService.getCurrentRate(currentCode: currentCode, completionHandler: { response in
            DispatchQueue.main.async {
                print(response)
                guard let amount = Double(self.amountTF.text!) else {return}
                print("rate is present")
                self.resultLabel.text = "You can buy \(amount/response.rate_float) bitcoin"
            }
        })
        
    }
}

extension ConverterViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
