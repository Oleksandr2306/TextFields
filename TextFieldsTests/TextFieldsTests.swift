//
//  TextFieldsTests.swift
//  TextFieldsTests
//
//  Created by Oleksandr Melnyk on 31.07.2022.
//

import XCTest
import UIKit
@testable import TextFields

final class TextFieldsTests: XCTestCase {
    
    private var sut: TextValidator!
    
    override func setUp() {
        sut = TextValidator()
    }
    
    override func tearDown() {
        sut = nil
    }
    
    func test_correctInputMask() throws {
        let inputText = "sssss444"
        let expectedText = "sssss-44"
        
        let maskedText = sut.maskedText(input: inputText)
        
        XCTAssertEqual(maskedText, expectedText)
    }
    
    func test_wrongInputMask() throws {
        let inputText = "sss-sss444-444"
        let expectedText = "sssss-44444"
        
        let maskedText = sut.maskedText(input: inputText)
        
        XCTAssertEqual(maskedText, expectedText)
    }
    
    func test_passwordHasLowercase() throws {
        let inputText = "SsS"
        
        XCTAssertTrue(sut.passwordTextHasLowercase(input: inputText))
    }
    
    func test_passwordHasUppercase() throws {
        let inputText = "sSs"
        
        XCTAssertTrue(sut.passwordTextHasUppercase(input: inputText))
    }
    
    func test_passwordHasDigit() throws {
        let inputText = "Ss3S"
        
        XCTAssertTrue(sut.passwordTextHasDigit(input: inputText))
    }
    
    func test_passwordIsFull() throws {
        let inputText = "SsS34ssdws"
        
        XCTAssertTrue(sut.passwordTextIsFull(input: inputText))
    }
    
}
