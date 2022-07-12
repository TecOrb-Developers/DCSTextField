//
//  DCSTextField.swift
//  JobsHolaClient
//
//  Created by Dinesh on 25/07/20.
//  Copyright © 2020 Dinesh. All rights reserved.
//

import UIKit



enum ValueType: Int {
    case none
    case onlyLetters
    case onlyNumbers
    case phoneNumber   // Allowed "+0123456789"
    case phoneNumberWithPlus
    case alphaNumeric
    case fullName// Allowed letters and space
}

@IBDesignable class DCSTextField: UITextField {
    @IBInspectable var errorDelimeter: String = ""
    var isError: Bool = false
    var placeHolderColor:UIColor = UIColor.gray.withAlphaComponent(0.9){
        didSet{
            setupPlaceholder()
        }
    }
    
    override var font: UIFont?{
        didSet{
            setupPlaceholder()
        }
    }
    
    var errorColor:UIColor = UIColor.red.withAlphaComponent(0.9){
        didSet{
            setupPlaceholder()
        }
    }
    
    override var placeholder: String?{
        didSet{
            setupPlaceholder()
        }
    }

    
    @IBInspectable var maxLength: Int = 0 // Max character length
    var valueType: ValueType = ValueType.none // Allowed characters

    /************ Added new feature **********************/
    @IBInspectable var allowedCharInString: String = ""

    
    // MARK:- Init
    required init?(coder aDecoder:NSCoder) {
        super.init(coder:aDecoder)
        setup()
    }
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        setup()
    }
    
    private func setup(){
    }
    
    func setupPlaceholder(){
        //write here to setup attributted placeholder
        guard let plch = self.placeholder else {
            return
        }
        let myplaceholder = plch.trimmingCharacters(in: CharacterSet(charactersIn: "*"))
        let attr = NSMutableAttributedString()
        let font = self.font ?? UIFont.systemFont(ofSize: 14)
        let placeholderAttributes = [NSAttributedString.Key.foregroundColor:self.placeHolderColor, NSAttributedString.Key.font: font]
        let errorAttributes = [NSAttributedString.Key.foregroundColor:self.errorColor, NSAttributedString.Key.font: font]
        let attributtedPlaceholder = NSMutableAttributedString(string: myplaceholder, attributes: placeholderAttributes)
        let errorDelimeter = (self.errorDelimeter == "") ? " " : self.errorDelimeter
        let attributtedError = NSMutableAttributedString(string: errorDelimeter, attributes: isError ? errorAttributes : placeholderAttributes)
        attr.append(attributtedPlaceholder)
        attr.append(attributtedError)
        self.attributedPlaceholder = attr
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return self.verifyFields(shouldChangeCharactersIn: range, replacementString: string)
    }
    
    func verifyFields(shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch valueType {
        case .none:
            break // Do nothing
            
        case .onlyLetters:
            let characterSet = CharacterSet.letters
            if string.rangeOfCharacter(from: characterSet.inverted) != nil {
                return false
            }
            
        case .onlyNumbers:
            let numberSet = CharacterSet.decimalDigits
            if string.rangeOfCharacter(from: numberSet.inverted) != nil {
                return false
            }
            
        case .phoneNumber:
            let phoneNumberSet = CharacterSet(charactersIn: "0123456789")
            if string.rangeOfCharacter(from: phoneNumberSet.inverted) != nil {
                return false
            }
            
        case .phoneNumberWithPlus:
            let phoneNumberSet = CharacterSet(charactersIn: "+0123456789")
            if string.rangeOfCharacter(from: phoneNumberSet.inverted) != nil {
                return false
            }
            
        case .alphaNumeric:
            let alphaNumericSet = CharacterSet.alphanumerics
            if string.rangeOfCharacter(from: alphaNumericSet.inverted) != nil {
                return false
            }
            
        case .fullName:
            var characterSet = CharacterSet.letters
            characterSet = characterSet.union(CharacterSet(charactersIn: " "))
            if string.rangeOfCharacter(from: characterSet.inverted) != nil {
                return false
            }
        }
        
        if let text = self.text, let textRange = Range(range, in: text) {
            let finalText = text.replacingCharacters(in: textRange, with: string)
            if maxLength > 0, maxLength < finalText.utf8.count {
                return false
            }
        }

        // Check supported custom characters
        if !self.allowedCharInString.isEmpty {
            let customSet = CharacterSet(charactersIn: self.allowedCharInString)
            if string.rangeOfCharacter(from: customSet.inverted) != nil {
                return false
            }
        }
        
        return true
    }
}


