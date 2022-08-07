//
//  TextFieldManager.swift
//  TextFields
//
//  Created by Oleksandr Melnyk on 31.07.2022.
//

import Foundation
import UIKit

final class TextValidator {
    
    func nonDigitTextFieldInput(textField: UITextField) {
        guard let text = textField.text else { return }
        textField.text = text.filter{ !$0.isNumber }
    }
    
    func limitTextFieldInput(textField: UITextField) -> Int {
        guard let text = textField.text else { return 0 }
        return text.count
    }
    
    func maskTextFieldInput(textField: UITextField) {
        guard let text = textField.text else { return }
        var resultString = ""
        
        for symbol in text {
            if resultString.shouldAppendDash {
                resultString.append("-")
            } else if resultString.shouldInsertLetter {
                symbol.isLetter ? resultString.append(symbol) : resultString.append("")
            } else if resultString.shouldInsertNumber {
                symbol.isNumber ? resultString.append(symbol) : resultString.append("")
            }
        }
        textField.text = resultString
    }
    
    func linkTextFieldInput(textField: UITextField) -> URL? {
        guard let text = textField.text else { return URL(string: "") }
        guard let url = URL(string: text) else { return URL(string: "") }
        
        if (url.absoluteString.hasPrefix("https://") || url.absoluteString.hasPrefix("http://")) && url.absoluteString.contains(".") {
            return url
        }
        
        return URL(string: "")
    }
    
    func passwordTextFieldInput(textField: UITextField) -> Float {
        var progress: Float = 0
        
        if passwordTextFieldIsFull(textField: textField) {
            progress += 0.25
        }
        
        if passwordTextFieldHasDigit(textField: textField) {
            progress += 0.25
        }
        
        if passwordTextFieldHasLowercase(textField: textField) {
            progress += 0.25
        }
        
        if passwordTextFieldHasUppercase(textField: textField) {
            progress += 0.25
        }
        
        return progress
    }
    
    func passwordTextFieldIsFull(textField: UITextField) -> Bool {
        guard let text = textField.text else { return false }
        
        if text.count >= 8 {
            return true
        }
        return false
    }
    
    func passwordTextFieldHasDigit(textField: UITextField) -> Bool {
        guard let text = textField.text else { return false }
        
        for symbol in text {
            if symbol.isNumber {
                return true
            }
        }
        return false
    }
    
    func passwordTextFieldHasLowercase(textField: UITextField) -> Bool {
        guard let text = textField.text else { return false }
        
        for symbol in text {
            if symbol.isLowercase {
                return true
            }
        }
        return false
    }
    
    func passwordTextFieldHasUppercase(textField: UITextField) -> Bool {
        guard let text = textField.text else { return false }
        
        for symbol in text {
            if symbol.isUppercase {
                return true
            }
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
