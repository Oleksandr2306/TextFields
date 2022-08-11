//
//  TextFieldsTests.swift
//  TextFieldsTests
//
//  Created by Oleksandr Melnyk on 31.07.2022.
//

import XCTest
import UIKit
@testable import TextFields

class TextFieldsTests: XCTestCase {
    
    var result: TextValidator!
    var textField: UITextField!
    
    override func setUp() {
        result = TextValidator()
        textField = UITextField()
    }
    
    override func tearDown() {
        result = nil
        textField = nil
    }
    
    func test_correctInputMask() throws {
        textField.text = "sssss-44444"
        result.maskTextFieldInput(textField: textField)
        XCTAssertEqual("sssss-44444", textField.text)
    }
    
    func test_wrongInputMask() throws {
        textField.text = "sss-sss444-444"
        result.maskTextFieldInput(textField: textField)
        XCTAssertEqual("sssss-44444", textField.text)
    }
    
    func test_passwordHasLowercase() throws {
        textField.text = "SsS"
        XCTAssertTrue(result.passwordTextFieldHasLowercase(textField: textField))
    }
    
    func test_passwordHasUppercase() throws {
        textField.text = "sSs"
        XCTAssertTrue(result.passwordTextFieldHasUppercase(textField: textField))
    }
    
    func test_passwordHasDigit() throws {
        textField.text = "Ss3S"
        XCTAssertTrue(result.passwordTextFieldHasDigit(textField: textField))
    }
    
    func test_passwordIsFull() throws {
        textField.text = "SsS34ssdws"
        XCTAssertTrue(result.passwordTextFieldIsFull(textField: textField))
    }
    
}
