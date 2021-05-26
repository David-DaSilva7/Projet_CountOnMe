//
//  SimpleCalcTests.swift
//  SimpleCalcTests
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import CountOnMe

class CalculatorTestCase: XCTestCase {
    
    var calculator: Calculator!

    override func setUp() {
        super.setUp()
        calculator = Calculator(currentText: "")
    }
    
    func testGivenExpressionIsEmpty_WhenLastElementAddedIsAnOperator_ThenReturnFalse() {
        calculator.currentText = "+"

        XCTAssertFalse(calculator.expressionIsCorrect)
    }

    // Clear all text and replace by 0
    func testGivenIsEmpty_WhenACButtonTapped_Then0ShouldBeDisplayed() {
        calculator.clearAll()

        XCTAssertEqual(calculator.currentText, "0")
    }

    // Clear last entry
    func testGivenIs2Plus2_WhenCButtonTapped_Then2PlusShouldBeDisplayed() {
        calculator.currentText = "2 + 2"

        calculator.clearLastEntry()

        XCTAssertEqual(calculator.currentText, "2 + ")
    }

    // Add operator
    func testGivenIs0_WhenMultiplicationOperatorButtonTapped_Then0AndMultiplicationOperatorShouldBeDisplayed() {
        calculator.currentText = "0"

        _ = calculator.addOperator(operator: "×")

        XCTAssertTrue(calculator.currentText == "0 × ")
    }

    func testGivenIs1Plus1Equal2_WhenPlusOperatorButtonTapped_ThenOperatorIsAddedAfterResult() {
        calculator.currentText = "1 + 1 = 2"

        _ = calculator.addOperator(operator: "+")

        XCTAssertTrue(calculator.currentText == "2 + ")
    }

    // Divided by 0
    func testGivenIs5DividedBy0_WhenIsImpossibleToDivideBooleanCalled_ThenIsImpossibleToDivideBooleanShouldReturnTrue() {
        calculator.currentText = "5 ÷ 0"

        XCTAssertTrue(calculator.isImpossibleToDivide)
    }

    func testGivenIs1DividedBy0_WhenEqualButtonTapped_ThenValidityElementOfTupleShouldReturnFalse() {
        calculator.currentText = "1 ÷ 0"

        XCTAssertEqual(calculator.calculate().validity, false)
        XCTAssertEqual(calculator.calculate().message, "Impossible de diviser par 0 !")
    }

    // Add two operators consecutively
    func testGivenIs1Plus_WhenMinusOperatorButtonTapped_ThenCanAddOperatorBooleanShouldReturnFalse() {
        calculator.currentText = "1 + "

        _ = calculator.addOperator(operator: "-")

        XCTAssertFalse(calculator.canAddOperator)
    }

    // Check if expression already has a result
    func testGivenIs1Plus1Equal2_WhenExpressionHasResultBooleanCalled_ThenExpressionHasResultBooleanShouldReturnTrue() {
        calculator.currentText = "1 + 1 = 2"

        XCTAssertTrue(calculator.expressionHasResult)
    }
    
    func testGivenIs9MultipliedBy12Plus96DividedBy3Minus4_WhenEqualOperatorButtonTapped_Then136ResultShouldBeDisplayed() {
        calculator.currentText = "9 x 12 + 96 / 3 - 4"
        
        _ = calculator.calculate()
        
        XCTAssertTrue(calculator.currentText == "9 x 12 + 96 / 3 - 4 = 136" )
    }

}
