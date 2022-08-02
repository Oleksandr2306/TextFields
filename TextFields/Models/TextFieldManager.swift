//
//  TextFieldManager.swift
//  TextFields
//
//  Created by Oleksandr Melnyk on 31.07.2022.
//

import Foundation
import UIKit
import SafariServices

final class TextFieldManager  {
    
    func setBlueBorderColor(textField: UITextField) {
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.blue.cgColor
        textField.layer.cornerRadius = 10
    }
    
    func setRedBorderColor(textField: UITextField) {
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.red.cgColor
        textField.layer.cornerRadius = 10
    }
    
    func setDefaultBorderColor(textField: UITextField) {
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(red: 118/256, green: 118/256, blue: 128/256, alpha: 0.12).cgColor
        textField.borderStyle = UITextField.BorderStyle.none
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
        textField.layer.cornerRadius = 10
    }
    
    func nonDigitTextFieldInput(textField: UITextField) {
        
        if let text = textField.text {
            textField.text = text.filter{!$0.isNumber}
        }
    }
    
    func limitTextFieldInput(textField: UITextField, symbolsNumber: UILabel) {
        guard let text = textField.text else { return }
        symbolsNumber.text = "\(10 - text.count)"
        
        if text.count > 10 {
            setRedBorderColor(textField: textField)
            symbolsNumber.textColor = .red
        } else {
            setBlueBorderColor(textField: textField)
            symbolsNumber.textColor = .black
        }
    }
    
    func maskTextFieldInput(textField: UITextField) {
        guard let text = textField.text else { return }
        var resultString = ""
        for i in text {
            if resultString.count == 5 {
                resultString.append("-")
            } else if i == "-" && !resultString.contains("-"){
                resultString.append(i)
            } else if !resultString.contains("-") {
                if i.isLetter {
                    resultString.append(i)
                }
            } else if resultString.contains("-") && resultString.count < 11 {
                if i.isNumber {
                    resultString.append(i)
                }
            }
        }
        textField.text = resultString
    }
    
    func linkTextFieldInput(textField: UITextField) -> URL {
        guard let text = textField.text else { return URL(string: "")! }

        guard let url = URL(string: text) else { return URL(string: "")! }
        
        return url
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
        
        for i in text {
            if i.isNumber {
                return true
            }
        }
        return false
    }
    
     func passwordTextFieldHasLowercase(textField: UITextField) -> Bool {
        guard let text = textField.text else { return false }
        
        for i in text {
            if i.isLowercase {
                return true
            }
        }
        return false
    }
    
     func passwordTextFieldHasUppercase(textField: UITextField) -> Bool {
        guard let text = textField.text else { return false }
        
        for i in text {
            if i.isUppercase {
                return true
            }
        }
        return false
    }
}
