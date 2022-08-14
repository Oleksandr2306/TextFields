//
//  TextFieldsViewController.swift
//  TextFields
//
//  Created by Oleksandr Melnyk on 31.07.2022.
//

import UIKit
import SafariServices

final class TextFieldsViewController: UIViewController {
    @IBOutlet weak private var noDigitTextField: UITextField!
    @IBOutlet weak private var limitTextField: UITextField!
    @IBOutlet weak private var maskTextField: UITextField!
    @IBOutlet weak private var passwordTextField: UITextField!
    @IBOutlet weak private var linkTextField: UITextField!
    
    @IBOutlet weak private var symbolsNumberLabel: UILabel!
    @IBOutlet var passwordConditionLabels: [UILabel]!
    
    @IBOutlet weak private var progressBar: UIProgressView!
    
    lazy private var textValidator = TextValidator()
    private var timer: Timer!
    
    private let defaultBorderColor = UIColor(red: 118/256, green: 118/256, blue: 128/256, alpha: 0.12)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        noDigitTextField.delegate = self
        limitTextField.delegate = self
        maskTextField.delegate = self
        linkTextField.delegate = self
        passwordTextField.delegate = self
        symbolsNumberLabel.text = "10"
        progressBar.progress = 0
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if passwordTextField.isEditing && self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction private func nonDigitTextFieldEditing(_ sender: UITextField) {
        guard let text = sender.text else { return }
        sender.text = textValidator.nonDigitTextFieldInput(input: text)
    }
    
    @IBAction private func limitTextFieldEditing(_ sender: UITextField) {
        guard let text = sender.text else { return }
        let symbolsNumber = textValidator.limitTextFieldInput(input: text)
        symbolsNumberLabel.text = "\(10 - symbolsNumber)"
        
        if symbolsNumber > 10 {
            setBorderColor(textField: sender, color: .systemRed)
            symbolsNumberLabel.textColor = .systemRed
        } else {
            setBorderColor(textField: sender, color: .systemBlue)
            symbolsNumberLabel.textColor = .black
        }
    }
    
    @IBAction private func maskTextFieldEditing(_ sender: UITextField) {
        guard let text = sender.text else { return }
        sender.text = textValidator.maskTextFieldInput(input: text)
    }
    
    @IBAction private func linkTextFieldTapped(_ sender: UITextField) {
        guard sender.text!.isEmpty else { return }
        sender.text = "https://"
    }
    
    @IBAction private func linkTextFieldEditing(_ sender: UITextField) {
        timer?.invalidate()
        guard let text = sender.text else { return }
        guard let url = textValidator.linkTextFieldInput(input: text) else { return }
        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { _ in
            self.openSafari(url: url)
        })
        
    }
    
    @IBAction private func passwordTextFieldEditing(_ sender: UITextField) {
        guard let text = sender.text else { return }
        let progress = textValidator.passwordTextFieldInput(input: text)
        progressBar.progress = progress
        progressBar.progressTintColor = setProgressBarColor(progress: progress)
        
        if textValidator.passwordTextFieldIsFull(input: text) {
            passwordConditionLabels[0].text = "✓ min length 8 characters."
            passwordConditionLabels[0].textColor = .systemGreen
        } else {
            passwordConditionLabels[0].text = "- min length 8 characters."
            passwordConditionLabels[0].textColor = .black
        }
        if textValidator.passwordTextFieldHasDigit(input: text) {
            passwordConditionLabels[1].text = "✓ min 1 digit."
            passwordConditionLabels[1].textColor = .systemGreen
        } else {
            passwordConditionLabels[1].text = "- min 1 digit."
            passwordConditionLabels[1].textColor = .black
        }
        if textValidator.passwordTextFieldHasLowercase(input: text) {
            passwordConditionLabels[2].text = "✓ min 1 lowercased."
            passwordConditionLabels[2].textColor = .systemGreen
        } else {
            passwordConditionLabels[2].text = "- min 1 lowercased."
            passwordConditionLabels[2].textColor = .black
        }
        if textValidator.passwordTextFieldHasUppercase(input: text) {
            passwordConditionLabels[3].text = "✓ min 1 uppercased."
            passwordConditionLabels[3].textColor = .systemGreen
        } else {
            passwordConditionLabels[3].text = "- min 1 uppercased."
            passwordConditionLabels[3].textColor = .black
        }
    }
    
    private func openSafari(url: URL) {
        let safariVewController = SFSafariViewController(url: url)
        present(safariVewController, animated: true)
    }
    
    private func setDefaultBorders() {
        setBorderColor(textField: noDigitTextField, color: defaultBorderColor)
        setBorderColor(textField: limitTextField, color: defaultBorderColor)
        setBorderColor(textField: maskTextField, color: defaultBorderColor)
        setBorderColor(textField: passwordTextField, color: defaultBorderColor)
        setBorderColor(textField: linkTextField, color: defaultBorderColor)
    }
    
    private func setBorderColor(textField: UITextField, color: UIColor) {
        textField.layer.borderWidth = 1
        textField.layer.borderColor = color.cgColor
        textField.layer.cornerRadius = 10
    }
    
    private func setProgressBarColor(progress: Float) -> UIColor {
        switch progress {
        case 0.25:
            return .systemRed
        case 0.5:
            return .systemOrange
        case 0.75:
            return .systemYellow
        case 1:
            return .systemGreen
        default:
            return .clear
        }
    }
}

extension TextFieldsViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        setBorderColor(textField: textField, color: .systemBlue)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        setBorderColor(textField: textField, color: defaultBorderColor)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
