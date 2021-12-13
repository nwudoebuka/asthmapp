//
//  AddDataTextFieldDelegate.swift
//  Asthm App
//
//  Created by Den Matiash on 16.01.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation
import UIKit
import common

class AddDataTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    private var validator: IValueValidator? = nil
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }

        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        return validator?.isValid(value: updatedText) ?? true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func bind(validator: IValueValidator) {
        self.validator = validator
    }
}
