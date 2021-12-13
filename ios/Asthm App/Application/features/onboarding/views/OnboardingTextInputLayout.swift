//
//  OnboardingTextInputLayout.swift
//  Asthm App
//
//  Created by Den Matiash on 11.02.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation
import UIKit

class OnboardingTextInputLayout: UIView {
    
    let textField = OnboardingTextField().apply {
        $0.keyboardType = .numberPad
        $0.setMaxCharacters(5)
    }
    private let label = BigBodyLabel().apply {
        $0.textColor = Palette.white
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        buildViewTree()
        setConstraints()
        addToolbarToKeyboard()
    }
    
    private func buildViewTree() {
        addSubview(textField)
        addSubview(label)
    }
    
    private func setConstraints() {
        textField.edgesToSuperview(excluding: .trailing)
        label.run {
            $0.leadingToTrailing(of: textField, offset: 2)
            $0.trailingToSuperview()
            $0.bottom(to: textField)
            $0.setContentHuggingPriority(.required, for: .horizontal)
        }
    }
    
    private func addToolbarToKeyboard() {
        textField.inputAccessoryView = UIToolbar().apply {
            $0.sizeToFit()
            $0.barTintColor = Palette.white
            $0.items = [
                UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
                UIBarButtonItem(title: "done".localized, style: .plain, target: self, action: #selector(onDoneTap))
            ]
        }
    }
    
    @objc private func onDoneTap() {
        textField.resignFirstResponder()
    }
    
    func bind(_ text: String) {
        label.text = text
    }
}
