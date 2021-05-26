//
//  Calculator.swift
//  CountOnMe
//
//  Created by David Da Silva on 07/05/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import Foundation

    
class Calculator {
        // MARK: - Internal properties
        var currentText = ""

        var expressionIsCorrect: Bool {
            isValidExpressionOrOperator()
        }

        var canAddOperator: Bool {
            isValidExpressionOrOperator()
        }

        var isImpossibleToDivide: Bool {
            return currentText.contains(" ÷ 0")
        }

        // check if currentText already contains an operation with a result or no
        var expressionHasResult: Bool {
            return currentText.firstIndex(of: "=") != nil
        }

        var expressionHasEnoughElement: Bool {
            return elements.count >= 3
        }

        // MARK: - Fileprivate properties
        fileprivate var elements: [String] {
            return currentText.split(separator: " ").map { "\($0)" }
        }

        // MARK: - Initialization
        init(currentText: String) {
            self.currentText = currentText
        }

        // MARK: - Internal functions
        // Clear calcul
        func clearAll() {
            currentText = ""
        }

        func removeLastEntryOfCurrentText() {
            if expressionHasResult {
                if let firstCharacterToTrim = currentText.firstIndex(of: "=") {
                    for character in currentText {
                        if let index = currentText.lastIndex(of: character) {
                            if index >= currentText.index(before: firstCharacterToTrim) {
                                currentText.remove(at: index)
                            }
                        }
                    }
                }
            } else {
                if let lastCharacter = currentText.last, lastCharacter == " " {
                    currentText.removeLast()
                }
                currentText.removeLast()
            }
        }

        // Remove last element
        func clearLastEntry() {
            if currentText == "0" {
                return
            }

            removeLastEntryOfCurrentText()
        }
        
        func emptyCurrentTextIfExpressionHasResult() {
            if expressionHasResult {
                currentText = ""
            }
        }

        // Add number for calculation
        func addNumber(number: String) {
            emptyCurrentTextIfExpressionHasResult()
            currentText = currentText == "0" ? number : currentText + number
        }

        // Add operator for calculation
        func addOperator(operator symbol: String) -> Bool {
            guard canAddOperator else {
                return false
            }

            if let lastElement = elements.last, expressionHasResult {
                currentText = lastElement
            }

            currentText += " \(symbol) "
            return true
        }

        func calculate() -> (validity: Bool, message: String) {
            guard expressionIsCorrect else {
                return (false, "Veuillez entrer une expression correcte.")
            }

            guard expressionHasEnoughElement else {
                return (false, "Veuillez démarrer un nouveau calcul.")
            }

            if expressionHasResult {
                if let lastElement = elements.last {
                    currentText = lastElement
                    return (true, "\(lastElement)")
                }
            }

            var operations = elements
            var result: Float = 0
            var index = 0

            func executeOperation(_ signOperator: SignOperator) {
                if let firstOperand = Float(operations[index-1]), let secondOperand = Float(operations[index+1]) {
                    switch signOperator {
                    case .addition:
                        result = firstOperand + secondOperand
                    case .substraction:
                        result = firstOperand - secondOperand
                    case .multiplication:
                        result = firstOperand * secondOperand
                    case .division:
                        result = firstOperand / secondOperand
                    }

                    operations.remove(at: index+1)
                    operations.remove(at: index)
                    operations.remove(at: index-1)
                    operations.insert("\(result)", at: index-1)
                    index = 0
                }
            }

            // Iterate over operations while an operator still here
            while index < operations.count - 1 {
                if operations.contains("×") || operations.contains("÷") {
                    if operations[index] == "×" {
                        executeOperation(.multiplication)
                    } else if operations[index] == "÷" {
                        if isImpossibleToDivide {
                            return (false, "Impossible de diviser par 0 !")
                        } else {
                            executeOperation(.division)
                        }
                    }
                } else {
                    if operations[index] == "+" {
                        executeOperation(.addition)
                    } else if operations[index] == "-" {
                        executeOperation(.substraction)
                    }
                }
                index += 1
            }

            if let result = operations.first, let floatResult = Float(result) {
                currentText.append(" = \(floatResult.clean)")
            }

            return (true, "")
        }

        // MARK: - Fileprivate functions
        // Check if last element is an operator when equal button is pressed
        fileprivate func isValidExpressionOrOperator() -> Bool {
            return elements.last != "÷" && elements.last != "×" && elements.last != "-" && elements.last != "+"
        }

        // MARK: - Fileprivate enumeration
        fileprivate enum SignOperator {
            case addition, substraction, multiplication, division
        }
    }

