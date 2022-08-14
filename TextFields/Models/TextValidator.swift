//
//  TextFieldManager.swift
//  TextFields
//
//  Created by Oleksandr Melnyk on 31.07.2022.
//

import Foundation
import UIKit

final class TextValidator {
    
    func nonDigitTextFieldInput(input: String) -> String {
        let result = input.filter{ !$0.isNumber }
        return result
    }
    
    func limitTextFieldInput(input: String) -> Int {
        return input.count
    }
    
    func maskTextFieldInput(input: String) -> String {
        var resultString = ""
        
        for symbol in input {
            if resultString.shouldAppendDash {
                resultString.append("-")
            } else if resultString.shouldInsertLetter {
                symbol.isLetter ? resultString.append(symbol) : resultString.append("")
            } else if resultString.shouldInsertNumber {
                symbol.isNumber ? resultString.append(symbol) : resultString.append("")
            }
        }
        return resultString
    }
    
    func linkTextFieldInput(input: String) -> URL? {
        guard let url = URL(string: input) else { return URL(string: "") }
        
        if isValidURL(url: url) {
            return url
        }
        
        return URL(string: "")
    }
    
    func passwordTextFieldInput(input: String) -> Float {
        var progress: Float = 0
        
        if passwordTextFieldIsFull(input: input) {
            progress += 0.25
        }
        
        if passwordTextFieldHasDigit(input: input) {
            progress += 0.25
        }
        
        if passwordTextFieldHasLowercase(input: input) {
            progress += 0.25
        }
        
        if passwordTextFieldHasUppercase(input: input) {
            progress += 0.25
        }
        
        return progress
    }
    
    func passwordTextFieldIsFull(input: String) -> Bool {
        if input.count >= 8 {
            return true
        }
        return false
    }
    
    func passwordTextFieldHasDigit(input: String) -> Bool {
        for symbol in input {
            if symbol.isNumber {
                return true
            }
        }
        return false
    }
    
    func passwordTextFieldHasLowercase(input: String) -> Bool {
        for symbol in input {
            if symbol.isLowercase {
                return true
            }
        }
        return false
    }
    
    func passwordTextFieldHasUppercase(input: String) -> Bool {
        for symbol in input {
            if symbol.isUppercase {
                return true
            }
        }
        return false
    }
    
    private func isValidURL(url: URL) -> Bool {
        if (url.absoluteString.hasPrefix("https://") || url.absoluteString.hasPrefix("http://")) && url.absoluteString.contains(".") {
            return true
        }
        return false
    }
}

private extension String {
    
    var shouldInsertNumber: Bool {
        self.count < 11 && self.contains("-")
    }
    
    var shouldInsertLetter: Bool {
        !self.contains("-")
    }
    
    var shouldAppendDash: Bool {
        self.count == 5
    }
}
