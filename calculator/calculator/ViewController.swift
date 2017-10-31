//
//  ViewController.swift
//  calculator
//
//  Created by Bram Honingh on 25-09-17.
//  Copyright © 2017 DigitalCoder. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let currencyUrlString: String = "https://api.fixer.io/latest?base="
    
    var previousNumber: Double = 0
    var currentNumber: String = ""
    var operation: Int = 0
    var lastOutcome: Double = 0
    var isSecondNumber = false
    var isSecondOperator = false
    
    struct Currency: Decodable {
        let base: String
        let date: String
        let rates: Rates
    }
    
    struct Rates: Decodable {
        let USD: Double?
        let EUR: Double?
    }
    
    @IBOutlet weak var inputLabel: UILabel!
    
    @IBOutlet weak var label: UILabel!
    
    @IBAction func numbers(_ sender: UIButton)
    {
        
        if sender.tag == 0 {
            inputLabel.text = inputLabel.text! + "."
            label.text = label.text! + "."
            currentNumber = currentNumber + "."
        } else {
            inputLabel.text = inputLabel.text! + String(sender.tag - 1)
            currentNumber = currentNumber + String(sender.tag - 1)
            
            if isSecondNumber {
                displayOutcome()
            } else {
                label.text = label.text! + String(sender.tag - 1)
            }
        }
    }
    
    @IBAction func buttons(_ sender: UIButton)
    {
        
        if inputLabel.text != "" && sender.tag != 11 && sender.tag != 16 {
            
            if operation == 0 {
                previousNumber = Double(currentNumber)!
            } else {
                isSecondOperator = true
                previousNumber = lastOutcome
            }
            
            operation = sender.tag
            addOperationToScreen(senderTag: operation)
            isSecondNumber = true
            currentNumber = ""
            
        } else if sender.tag == 16 && operation != 16 {
//            Equal-sign Button press
            if !isSecondNumber {
                displayOutcome()
            }
            
        } else if sender.tag == 11 {
//            Reset button press
            
            previousNumber = 0
            lastOutcome = 0
            inputLabel.text = ""
            label.text = ""
            operation = 0
            isSecondNumber = false
            isSecondOperator = false
            currentNumber = ""
        }
        
    }
    
    func displayOutcome() {
        
        var calculation: Double = 0

        switch operation {
        case 12:
            if operation == 12 {
//                Divide
                calculation = previousNumber / Double(currentNumber)!
            }
            break
        case 13:
            if operation == 13 {
//                Multiply
                calculation = previousNumber * Double(currentNumber)!
            }
            break
        case 14:
            if operation == 14 {
//                Subtract
                calculation = previousNumber - Double(currentNumber)!
            }
            break
        case 15:
            if operation == 15 {
//                Add
                calculation = previousNumber + Double(currentNumber)!
            }
            break
        default:
            calculation = previousNumber
            break
        }

        lastOutcome = calculation
        label.text = String(checkIfIntAndCastToString(number: calculation))
    }
    
    func checkIfIntAndCastToString(number: Double) -> String {
        if floor(number) == number {
            return String(Int(number))
        } else {
            return String(number)
        }
    }
    
    func addOperationToScreen(senderTag: Int) {
        
        switch senderTag {
        case 12:
            // Divide
            inputLabel.text = inputLabel.text! + "/"
            break
        case 13:
            // Multiply
            inputLabel.text = inputLabel.text! + "x"
            break
        case 14:
            // Minus
            inputLabel.text = inputLabel.text! + "-"
            break
        case 15:
            // Plus
            inputLabel.text = inputLabel.text! + "+"
            break
        default:
            break
        }
    }
    
    @IBAction func currencyButtons(_ sender: UIButton) {
        if (sender.tag == 1 && label.text != "") {
//            EUR to USD
            let currencyAPIUrl = URL(string: currencyUrlString + "EUR")
            getCurrencyData(url: currencyAPIUrl!, from: "EUR")
            
        } else if (sender.tag == 2 && label.text != "") {
//            USD to EUR
            let currencyAPIUrl = URL(string: currencyUrlString + "USD")
            getCurrencyData(url: currencyAPIUrl!, from: "USD")
        }
    }
    
    func getCurrencyData(url: URL, from: String) {
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            
            guard let data = data else { return }
            
            do {
                let jsonData = try JSONDecoder().decode(Currency.self, from: data)
                
                DispatchQueue.main.async {
                    var labelNumber: Double = 0
                    
                    if self.lastOutcome != 0 {
                        labelNumber = self.lastOutcome
                    } else {
                        labelNumber = Double(self.currentNumber)!
                    }
                    
                    if (from == "EUR") {
                        self.label.text = "$" + String(Double(labelNumber) * jsonData.rates.USD!)
                    } else if (from == "USD") {
                        self.label.text = "€" + String(Double(labelNumber) * jsonData.rates.EUR!)
                    }
                    
                }
            
            } catch {
                print("ERR")
            }
            
            }.resume()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.adjustsFontSizeToFitWidth = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

