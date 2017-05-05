//
//  CalculatorViewController.swift
//  StanfordCalculator
//
//  Created by Anna Stavropoulos on 5/4/17.
//  Copyright © 2017 Jetmax. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var sequenceDispaly: UILabel!

    var userIsInTheMiddleOfTyping = false
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display!.text!
            display.text = textCurrentlyInDisplay + digit!
        } else{
            display.text = digit
            userIsInTheMiddleOfTyping = displayValue != 0
        }
    }

    @IBAction func touchDecimal(_ sender: Any)
    {
        if userIsInTheMiddleOfTyping && !display!.text!.contains(".")
        {
            display.text = display!.text! + "."
        }
    }
    
    private var brain = CalculatorBrain()

    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        if let mathmaticalSymbol = sender.currentTitle {
            brain.performOperation(mathmaticalSymbol)
        }
        if let result = brain.result {
            displayValue = result
        }
        
        sequenceDispaly.text = brain.sequenceString
    }
    
    @IBAction func clear(_ sender: Any) {
        brain = CalculatorBrain()
        displayValue = 0
        sequenceDispaly.text = ""
    }
}
