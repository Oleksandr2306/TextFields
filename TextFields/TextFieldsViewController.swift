//
//  TextFieldsViewController.swift
//  TextFields
//
//  Created by Oleksandr Melnyk on 31.07.2022.
//

import UIKit
import SafariServices

class TextFieldsViewController: UIViewController {
    @IBOutlet weak private var noDigitTextField: UITextField!
    @IBOutlet weak private var limitTextField: UITextField!
    @IBOutlet weak private var maskTextField: UITextField!
    @IBOutlet weak private var passwordTextField: UITextField!
    @IBOutlet weak private var linkTextField: UITextField!
    
    @IBOutlet weak private var symbolsNumberLabel: UILabel!
    @IBOutlet weak private var conditionLabel1: UILabel!
    @IBOutlet weak private var conditionLabel2: UILabel!
    @IBOutlet weak private var conditionLabel3: UILabel!
    @IBOutlet weak private var conditionLabel4: UILabel!
    
    @IBOutlet weak private var progressBar: UIProgressView!
    
    private var textFieldManager = TextFieldManager()
    private var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noDigitTextField.delegate = self
        limitTextField.delegate = self
        maskTextField.delegate = self
        linkTextField.delegate = self
        passwordTextField.delegate = self
        symbolsNumberLabel.text = "10"
        progressBar.progress = 0
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction private func nonDigitTextFieldEditing(_ sender: UITextField) {
        textFieldManager.nonDigitTextFieldInput(textField: sender)
    }
    
    @IBAction private func limitTextFieldEditing(_ sender: UITextField) {
        textFieldManager.limitTextFieldInput(textField: sender, symbolsNumber: symbolsNumberLabel)
    }
    
    @IBAction private func maskTextFieldEditing(_ sender: UITextField) {
        textFieldManager.maskTextFieldInput(textField: sender)
    }
    
    
    @IBAction private func linkTextFieldTapped(_ sender: UITextField) {
        sender.text = "https://"
    }
    
    @IBAction private func linkTextFieldEditing(_ sender: UITextField) {
        timer = Timer()
        timer?.invalidate()
        guard let symbolsNumber = sender.text?.count else { return }
        if symbolsNumber > 8 {
            timer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(startTimer), userInfo: nil, repeats: false)
        }
    }
    
    @IBAction private func passwordTextFieldEditing(_ sender: UITextField) {
        let progress = textFieldManager.passwordTextFieldInput(textField: sender)
        progressBar.progress = progress
        
        switch progress {
        case 0.25:
            progressBar.progressTintColor = .red
            break
        case 0.5:
            progressBar.progressTintColor = .orange
            break
        case 0.75:
            progressBar.progressTintColor = .yellow
            break
        case 1:
            progressBar.progressTintColor = .green
            break
        default:
            break
        }
        
        if textFieldManager.passwordTextFieldIsFull(textField: sender) {
            conditionLabel1.text = "✓ min length 8 characters."
            conditionLabel1.textColor = .green
        } else {
            conditionLabel1.text = "- min length 8 characters."
            conditionLabel1.textColor = .black
        }
        if textFieldManager.passwordTextFieldHasDigit(textField: sender) {
            conditionLabel2.text = "✓ min 1 digit."
            conditionLabel2.textColor = .green
        } else {
            conditionLabel2.text = "- min 1 digit."
            conditionLabel2.textColor = .black
        }
        if textFieldManager.passwordTextFieldHasLowercase(textField: sender) {
            conditionLabel3.text = "✓ min 1 lowercased."
            conditionLabel3.textColor = .green
        } else {
            conditionLabel3.text = "- min 1 lowercased."
            conditionLabel3.textColor = .black
        }
        if textFieldManager.passwordTextFieldHasUppercase(textField: sender) {
            conditionLabel4.text = "✓ min 1 uppercased."
            conditionLabel4.textColor = .green
        } else {
            conditionLabel4.text = "- min 1 uppercased."
            conditionLabel4.textColor = .black
        }
    }
    
    @objc private func startTimer() {
        timer?.invalidate()
        let url = textFieldManager.linkTextFieldInput(textField: linkTextField)
        if url.absoluteString.hasPrefix("https://") || url.absoluteString.hasPrefix("http://") {
            let safariVewController = SFSafariViewController(url: url)
            present(safariVewController, animated: true)
        } else {
            textFieldManager.setRedBorderColor(textField: linkTextField)
        }
    }
    
    private func setDefaultBorders() {
        textFieldManager.setDefaultBorderColor(textField: noDigitTextField)
        textFieldManager.setDefaultBorderColor(textField: limitTextField)
        textFieldManager.setDefaultBorderColor(textField: maskTextField)
        textFieldManager.setDefaultBorderColor(textField: limitTextField)
        textFieldManager.setDefaultBorderColor(textField: passwordTextField)
    }
    
}

extension TextFieldsViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textFieldManager.setBlueBorderColor(textField: textField)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textFieldManager.setDefaultBorderColor(textField: textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
