//
//  TextFieldManager.swift
//  TextFields
//
//  Created by Oleksandr Melnyk on 31.07.2022.
//

import Foundation
import UIKit

final class TextValidator {
    
    func nonDigitText(input: String) -> String {
        let result = input.filter{ !$0.isNumber }
        return result
    }
    
    func limitedText(input: String) -> Int {
        return input.count
    }
    
    func maskedText(input: String) -> String {
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
    
    func linkText(input: String) -> URL? {
        guard let url = URL(string: input) else { return URL(string: "") }
        
        if isValidURL(url: url) {
            return url
        }
        
        return URL(string: "")
    }
    
    func passwordText(input: String) -> Float {
        var progress: Float = 0
        
        if passwordTextIsFull(input: input) {
            progress += 0.25
        }
        
        if passwordTextHasDigit(input: input) {
            progress += 0.25
        }
        
        if passwordTextHasLowercase(input: input) {
            progress += 0.25
        }
        
        if passwordTextHasUppercase(input: input) {
            progress += 0.25
        }
        
        return progress
    }
    
    func passwordTextIsFull(input: String) -> Bool {
        if input.count >= 8 {
            return true
        }
        return false
    }
    
    func passwordTextHasDigit(input: String) -> Bool {
        for symbol in input {
            if symbol.isNumber {
                return true
            }
        }
        return false
    }
    
    func passwordTextHasLowercase(input: String) -> Bool {
        for symbol in input {
            if symbol.isLowercase {
                return true
            }
        }
        return false
    }
    
    func passwordTextHasUppercase(input: String) -> Bool {
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
