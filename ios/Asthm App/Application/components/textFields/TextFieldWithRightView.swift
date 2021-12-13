//
//  TextFieldWithRightView.swift
//  Asthm App
//
//  Created by Den Matiash on 16.01.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation
import UIKit
import common

class TextFieldWithRightView: UIView {
    
    private let textField = UITextFieldWithPaddings().apply {
        $0.backgroundColor = Palette.solitude
        $0.textColor = Palette.royalBlue
        $0.font = Font.bigBody
        $0.keyboardType = .numberPad
    }
    private let appendView = UIView().apply {
        $0.backgroundColor = Palette.solitude
    }
    private let appendLabel = BigBodyLabel().apply {
        $0.textColor = Palette.ebonyClay
        $0.numberOfLines = 1
    }
    private var onTextChange: (String) -> () = { _ in }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        layer.run {
            $0.cornerRadius = 10
            $0.masksToBounds = true
        }
        
        buildViewTree()
        setConstraints()
        setInteractions()
        addToolbarToKeyboard()
    }
    
    private func buildViewTree() {
        [textField, appendView].forEach(addSubview)
        appendView.addSubview(appendLabel)
    }
    
    private func setConstraints() {
        textField.run {
            $0.leadingToSuperview()
            $0.verticalToSuperview()
            $0.width(56)
        }
        
        appendView.run {
            $0.leadingToTrailing(of: textField)
            $0.top(to: textField)
            $0.bottom(to: textField)
            $0.trailingToSuperview()
        }
        
        appendLabel.edgesToSuperview(insets: .right(12))
    }
    
    private func setInteractions() {
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
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
    
    @objc private func textFieldDidChange() {
        onTextChange(textField.text ?? "")
    }
    
    func bind(_ uiModel: AddDataItem.MeasureUIModel) {
        appendLabel.text = uiModel.measureUnit
        textField.delegate = uiModel.textFieldValidator
        textField.placeholder = uiModel.hint
        onTextChange = uiModel.onDataChange
        if let value = uiModel.value {
            textField.text = String(value)
        } else {
            textField.text = ""
        }
    }
}

fileprivate class UITextFieldWithPaddings: UITextField {
    
    private let padding = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
