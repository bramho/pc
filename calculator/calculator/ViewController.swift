//
//  ViewController.swift
//  calculator
//
//  Created by Bram Honingh on 25-09-17.
//  Copyright © 2017 DigitalCoder. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var numberOnScreen: Double = 0
    var previousNumber: Double = 0
    var lastOutcome: Double = 0
    var nextNumber: String = "0"
    var performingMath = false
    var isSecondOperator = false
    var operation = 0
    var lastOperation = 0
    
    @IBOutlet weak var inputLabel: UILabel!
    
    @IBOutlet weak var label: UILabel!
    
    @IBAction func numbers(_ sender: UIButton)
    {
        print("")
        print("PERFORMING MATH: " + String(performingMath))
        print("")
        print("IS SECOND OPERATOR: " + String(isSecondOperator))
        print("")
        print("OPERATION: " + String(operation))
        print("")
        
        
        if performingMath == true {
            inputLabel.text = inputLabel.text! + String(sender.tag - 1)
            nextNumber = String(sender.tag - 1)
            performingMath = false
            
            displayOutcome()
        } else {
            inputLabel.text = inputLabel.text! + String(sender.tag - 1)
            print("")
            print("NEXT NUMBER (BEFORE): " + nextNumber)
            print("")
            nextNumber = String(Double(nextNumber)! + Double(sender.tag - 1))
            print("")
            print("NEXT NUMBER (AFTER): " + nextNumber)
            print("")
            print(String(sender.tag - 1))
            print("")
            
            if isSecondOperator {
                displayOutcome()
            } else {
                previousNumber = Double(inputLabel.text!)!
            }
            
            if operation != 0 {
                displayOutcome()
            }
        }
    }
    
    @IBAction func buttons(_ sender: UIButton)
    {
        print("BUTTON CLICK " + String(sender.tag))
        print("")
        
        if inputLabel.text != "" && sender.tag != 11 && sender.tag != 16 {
            
            if operation != 0 {
                
                isSecondOperator = true
                lastOperation = sender.tag
                operation = 0
                displayOutcome()
                
            } else {
                
                operation = sender.tag
                performingMath = true
                addOperationToScreen(senderTag: sender.tag)
                
            }
        
            
        } else if sender.tag == 16 && operation != 16 {
            inputLabel.text = inputLabel.text! + "="
            
            displayOutcome()
            
            operation = sender.tag
            
        } else if sender.tag == 11 {
            
            numberOnScreen = 0
            previousNumber = 0
            lastOutcome = 0
            inputLabel.text = ""
            label.text = ""
            operation = 0
            lastOperation = 0
            isSecondOperator = false
        }
        
    }
    
    func displayOutcome() {
        
        print("")
        print("LAST OUTCOME: " + String(lastOutcome))
        print("")
        print("PREVIOUS NUMBER: " + String(previousNumber))
        print("")
        print("NEXT NUMBER: " + String(nextNumber))
        print("")
        print("OPERATION: " + String(operation))
        print("")
        
        var calculation: Double = 0
        var firstCalculationNumber: Double = 0
        
        if lastOutcome == 0 {
            firstCalculationNumber = previousNumber
        } else {
            firstCalculationNumber = lastOutcome
        }

        switch operation {
        case 12:
            if operation == 12 {
                calculation = firstCalculationNumber / Double(nextNumber)!
                
                label.text = checkIfIntAndCastToString(number: calculation)
            }
            break
        case 13:
            if operation == 13 {
                calculation = firstCalculationNumber * Double(nextNumber)!
                
                label.text = checkIfIntAndCastToString(number: calculation)
            }
            break
        case 14:
            if operation == 14 {
                calculation = firstCalculationNumber - Double(nextNumber)!
                
                label.text = checkIfIntAndCastToString(number: calculation)
            }
            break
        case 15:
            if operation == 15 {
                calculation = firstCalculationNumber + Double(nextNumber)!
                
                label.text = checkIfIntAndCastToString(number: calculation)
            }
            break
        default:
            calculation = firstCalculationNumber
            break
        }
        
        if lastOperation != 0 {
            inputLabel.text = checkIfIntAndCastToString(number: lastOutcome)
            addOperationToScreen(senderTag: lastOperation)
            lastOperation = 0
        }

        previousNumber = calculation
//        inputLabel.text = checkIfIntAndCastToString(number: previousNumber)
    }
    
    func checkIfIntAndCastToString(number: Double) -> String {
        lastOutcome = number
        
        if floor(number) == number {
            return String(Int(number))
        } else {
            return String(number)
        }
    }
    
    func addOperationToScreen(senderTag: Int) {
        print("")
        print("PRINT OPERATOR")
        print("")
        
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.adjustsFontSizeToFitWidth = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

