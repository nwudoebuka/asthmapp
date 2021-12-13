//
//  OnboardingTextField.swift
//  Asthm App
//
//  Created by Den Matiash on 11.02.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation
import UIKit

class OnboardingTextField: UITextField, UITextFieldDelegate {
    
    private let hintLabel = BigBodyLabel()
    private var maxCharacters: Int? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        font = Font.bigBody
        borderStyle = .none
        tintColor = Palette.white
        autocorrectionType = .no
        spellCheckingType = .no
        textColor = Palette.white
        backgroundColor = Palette.cyanBlue
        delegate = self
        
        layer.run {
            $0.masksToBounds = false
            $0.shadowColor = Palette.white.cgColor
            $0.shadowOffset = CGSize(width: 0.0, height: 1.0)
            $0.shadowOpacity = 1.0
            $0.shadowRadius = 0.0
        }
        
        height(25)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func setMaxCharacters(_ count: Int) {
        maxCharacters = count
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= maxCharacters ?? Int(INT_MAX)
    }
}
