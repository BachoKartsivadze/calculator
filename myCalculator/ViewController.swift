//
//  ViewController.swift
//  myCalculator
//
//  Created by bacho kartsivadze on 30.11.22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var buttons: [UIButton]!
    @IBOutlet var textField: UITextField!
    
    var firstNum: Double?
    var secondnum: Double?
    var symbol: String?
    var currNum: Double = 0
    var numbersAfterPoint: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.text = "\(Int(currNum))"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureButtons()
    }

    func configureButtons() {
        for button in buttons {
            button.layer.cornerRadius = buttons[0].frame.height/2
            button.titleLabel?.font = button.titleLabel?.font.withSize(30)
        }
    }

    // handle button clicks
    @IBAction func clicknumberButton(_ sender: UIButton) {
        if firstNum != nil && symbol == nil {
            clear()
        }
        if numbersAfterPoint > -1 {
            numbersAfterPoint+=1
            currNum = currNum + Double((sender.titleLabel?.text)!)!/pow(10, Double(numbersAfterPoint))
            textField.text = "\(currNum)"
        } else {
            currNum = currNum * 10 + Double((sender.titleLabel?.text)!)!
            textField.text = "\(Int(currNum))"
        }
    }
    
    @IBAction func clickSymbolButton(_ sender: UIButton){
        let senderSymbol: String = (sender.titleLabel?.text)!
        
        if firstNum == nil && secondnum == nil {
            firstNum = currNum
            currNum = 0
            symbol = senderSymbol
        }else if firstNum != nil && currNum == 0{
            symbol = senderSymbol
        } else {
            secondnum = currNum
            let result = countResult(first: Double(firstNum!), second: Double(secondnum!), symbol: symbol ?? "0")
            firstNum = Double(result)
            secondnum = nil
            if isInt(number: result) {
                textField.text = "\(Int(result))"
            } else {
                textField.text = "\(result)"
            }
            currNum = 0
            symbol = senderSymbol
        }
        numbersAfterPoint = -1

    }
    
    @IBAction func equation() {
        if firstNum == nil {
            firstNum = currNum
        } else {
            secondnum = currNum
            let result = countResult(first: Double(firstNum!), second: Double(secondnum!), symbol: symbol ?? "0")
            firstNum = Double(result)
            secondnum = nil
            if isInt(number: result) {
                textField.text = "\(Int(result))"
            } else {
                textField.text = "\(result)"
            }
            currNum = 0
            symbol = nil
        }
        
        numbersAfterPoint = -1
    }
    
    @IBAction func clear() {
        firstNum = nil
        secondnum = nil
        currNum = 0
        textField.text = "0"
        numbersAfterPoint = -1
    }
    
    @IBAction func changeSymbol() {
        if currNum == 0 && firstNum != nil {
            firstNum = -firstNum!
            if isInt(number: firstNum!) {
                textField.text = "\(Int(firstNum!))"
            } else {
                textField.text = "\(firstNum!)"
            }
        } else {
            currNum = -currNum
            if isInt(number: firstNum!) {
                textField.text = "\(Int(firstNum!))"
            } else {
                textField.text = "\(currNum)"
            }
        }
    }
    
    @IBAction func clickPointButton() {
        let currText = textField.text
        textField.text = "\(Double(currText ?? "0") ?? 0)"
        numbersAfterPoint = 0
    }
    
    @IBAction func clickPercentButton() {
        currNum = currNum/100
        textField.text = "\(currNum)"
    }
    
    private func isInt(number: Double) -> Bool {
        if number == floor(number) {
            return true
        } else {
            return false
        }
    }
    
    
    
    
    
    private func countResult(first: Double, second: Double, symbol: String) -> Double {
        numbersAfterPoint = -1
        var result: Double = 0.0
        switch symbol {
        case "+": result = (first + second)
        case "-": result = (first - second)
        case "X": result = (first * second)
        case "/":
            if second == 0 {
                textField.text = "Division by zero"
                result = 0
            }else {
               result = (first / second)
            }
        default:
            textField.text = "something wrong :("
            return 0
        }
        let resultInInt = Int(result * 1000000)
        result = Double(resultInInt)/1000000
        return result
    }
}

