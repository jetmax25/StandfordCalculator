//
//  CalculatorBrain.swift
//  StanfordCalculator
//
//  Created by Anna Stavropoulos on 5/5/17.
//  Copyright © 2017 Jetmax. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    
    private var accumulator : Double?
    private var sequence = ""
    private var operandString = ""
    
    private enum Operation {
        case constant(Double)
        case unaryOperation( (Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
    }
    
    private var operations: Dictionary<String, Operation> = [
        "π" : Operation.constant(Double.pi),
        "e" : Operation.constant(M_E),
        "√" : Operation.unaryOperation(sqrt),
        "cos" : Operation.unaryOperation(cos),
        "±" : Operation.unaryOperation({-$0}),
        "X" : Operation.binaryOperation( { $0 * $1 } ),
        "÷" : Operation.binaryOperation( { $0 / $1 } ),
        "+" : Operation.binaryOperation({$0 + $1 } ),
        "-" : Operation.binaryOperation({$0 - $1}),
        "=" : Operation.equals
    ]
    
    mutating func performOperation( _ symbol : String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant( let value) :
                accumulator = value
                
            case .unaryOperation(let function):
                if accumulator != nil {
                    sequence = "\(symbol)( \(sequence) )"
                    accumulator = function(accumulator!)
                }
            case .binaryOperation(let function):
                if accumulator != nil {
                    pendingBinaryOperation = PendingBindaryOperation(function: function, firstOperand: accumulator!)
                    accumulator = nil
                    addSymbol(symbol)
                }
            case .equals:
                addSymbol(symbol)
                performPendingBinaryOperation()
            }
        }
    }
    
    private mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }
    
    private var pendingBinaryOperation: PendingBindaryOperation?
    
    private struct PendingBindaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand : Double
        
        func perform(with secondOperand: Double) -> Double{
            return function(firstOperand, secondOperand)
        }
    }
    
    private mutating func addSymbol(_ symbol: String)
    {
        sequence = sequence + symbol + " "
    }
    
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
        addSymbol(String(operand))
    }
    
    var result : Double? {
        get {
            return accumulator
        }
    }
    
    var sequenceString : String {
        get {
            return sequence
        }
    }
}
