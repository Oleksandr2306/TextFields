//
//  TextFieldsUITests.swift
//  TextFieldsUITests
//
//  Created by Oleksandr Melnyk on 31.07.2022.
//

import XCTest

class TextFieldsUITests: XCTestCase {

    var app: XCUIApplication!
    lazy var noDigitTextField = app.textFields["NoDigitTextField"]
    lazy var limitTextField = app.textFields["LimitTextField"]
    lazy var maskTextField = app.textFields["MaskTextField"]
    lazy var linkTextField = app.textFields["LinkTextField"]
    lazy var passwordTextField = app.secureTextFields["PasswordTextField"]
    lazy var symbolsNumberLabel = app.staticTexts["SymbolsNumberLabel"]
    lazy var progressBar = app.progressIndicators["ProgressBar"]
    lazy var conditionLabels = [app.staticTexts["ConditionLabel1"],
                                app.staticTexts["ConditionLabel2"],
                                app.staticTexts["ConditionLabel3"],
                                app.staticTexts["ConditionLabel4"]
    ]
    lazy var returnKey = app.buttons["Return"]
    lazy var deleteKey = XCUIKeyboardKey.delete
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    
    func test_UIExists() throws {
        XCTAssertTrue(noDigitTextField.exists)
        XCTAssertTrue(limitTextField.exists)
        XCTAssertTrue(maskTextField.exists)
        XCTAssertTrue(linkTextField.exists)
        XCTAssertTrue(passwordTextField.exists)
        XCTAssertTrue(symbolsNumberLabel.exists)
        XCTAssertTrue(progressBar.exists)
        for element in conditionLabels {
            XCTAssertTrue(element.exists)
        }
    }
    
    func test_keyBoard_closeFine() throws {
        noDigitTextField.tap()
        noDigitTextField.typeText("sssss")
        returnKey.tap()
        XCTAssertTrue(app.keyboards.count == 0)
        noDigitTextField.tap()
        app.tap()
        XCTAssertTrue(app.keyboards.count == 0)
    }
    
    func test_noDigitTextField_Input() throws {
        noDigitTextField.tap()
        noDigitTextField.typeText("qwerty 23 sss")
        let result = noDigitTextField.value as! String
        let expectedResult = "qwerty  sss"
        XCTAssertEqual(result, expectedResult)
    }
    
    func test_limitTextField_hasCorrectLabel() throws {
        limitTextField.tap()
        limitTextField.typeText("sssss sssss")
        let result = symbolsNumberLabel.label
        let expectedResult = "-1"
        XCTAssertEqual(result, expectedResult)
    }
    
    func test_maskTextField_Input() throws {
        maskTextField.tap()
        maskTextField.typeText("sdwdsddws")
        let result = maskTextField.value as! String
        let expectedResult = "sdwds-"
        XCTAssertEqual(result, expectedResult)
    }
    
    func test_linkTextField_hasStartingPrefix() throws {
        linkTextField.tap()
        let result = linkTextField.value as! String
        let expectedResult = "https://"
        XCTAssertEqual(result, expectedResult)
    }
    
    func test_linkTextField_inputValidLink() throws {
        linkTextField.tap()
        linkTextField.typeText("google.com.ua")
        XCTAssertTrue(app.otherElements["URL"].waitForExistence(timeout: 4))
    }
    
    func test_linkTextField_inputWrongLink() throws {
        linkTextField.tap()
        linkTextField.typeText("ssssss")
        XCTAssertFalse(app.otherElements["URL"].waitForExistence(timeout: 4))
    }
    
    func test_passwordTextField_HasCorrectLabels() throws {
        passwordTextField.tap()
        passwordTextField.typeText("sS1qwerty")
        let expectedResults = ["✓ min length 8 characters.",
                               "✓ min 1 digit.",
                               "✓ min 1 lowercased.",
                               "✓ min 1 uppercased."
        ]
        for result in 0...expectedResults.count - 1 {
            XCTAssertEqual(conditionLabels[result].label, expectedResults[result])
        }
    }
    
}
