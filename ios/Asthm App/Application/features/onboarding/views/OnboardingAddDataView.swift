//
//  OnboardingAddDataView.swift
//  Asthm App
//
//  Created by Den Matiash on 11.02.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation
import UIKit
import common

class OnboardingAddDataView: UIView {
    
    private let nameLabel = BigBodyLabel().apply {
        $0.text = "name".localized
        $0.textColor = Palette.white
    }
    private let nameTextField = OnboardingTextField()
    private let heightLabel = BigBodyLabel().apply {
        $0.text = "height".localized
        $0.textColor = Palette.white
    }
    private let heightTextLayoutFeet = OnboardingTextInputLayout().apply {
        $0.bind("ft".localized)
    }
    private let heightTextLayoutInch = OnboardingTextInputLayout().apply {
        $0.bind("in".localized)
    }
    private let heightTextLayoutMetric = OnboardingTextInputLayout().apply {
        $0.bind("cm".localized)
    }
    private let lengthConversionLabel = BigBodyLabel().apply {
        $0.textColor = Palette.white
    }
    enum LengthConversionType {
        case metric, imperial
    }
    private var lengthConversionType: LengthConversionType = .imperial {
        didSet {
            updateUI()
        }
    }
    private let genderLabel = BigBodyLabel().apply {
        $0.text = "gender".localized
        $0.textColor = Palette.white
    }
    private let genderStackView = UIStackView().apply {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
    }
    private let radioButtons: [RadioButtonOption] = [
        RadioButtonOption().apply { $0.bind("male".localized, Gender.male) },
        RadioButtonOption().apply { $0.bind("female".localized, Gender.female) },
        RadioButtonOption().apply { $0.bind("unspecified".localized, Gender.unspecified); $0.select() }
    ]
    private let birthDateLabel = BigBodyLabel().apply {
        $0.text = "birth_date".localized
        $0.textColor = Palette.white
    }
    private let datePicker = UIDatePicker().apply {
        $0.datePickerMode = .date
        $0.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
        $0.backgroundColor = Palette.white
    }
    private lazy var dateTextField = OnboardingTextField().apply {
        $0.inputView = datePicker
        $0.inputAccessoryView = UIToolbar().apply {
            $0.sizeToFit()
            $0.barTintColor = Palette.white
            $0.items = [
                UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
                UIBarButtonItem(title: "done".localized, style: .plain, target: self, action: #selector(onDoneTap))
            ]
        }
        $0.textAlignment = .center
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
        setInteractions()
        updateUI()
    }
    
    private func buildViewTree() {
        [nameLabel, nameTextField, heightLabel, heightTextLayoutFeet, heightTextLayoutInch, heightTextLayoutMetric,
         lengthConversionLabel, genderLabel, genderStackView, birthDateLabel, dateTextField].forEach(addSubview)
        radioButtons.forEach(genderStackView.addArrangedSubview)
    }
    
    private func setConstraints() {
        nameLabel.run {
            $0.topToSuperview()
            $0.leadingToSuperview()
        }
    
        nameTextField.run {
            $0.centerY(to: nameLabel)
            $0.leadingToSuperview(offset: 90)
            $0.trailingToSuperview()
        }
        
        heightLabel.run {
            $0.topToBottom(of: nameLabel, offset: 24)
            $0.leadingToSuperview()
        }
        
        heightTextLayoutFeet.run {
            $0.centerY(to: heightLabel)
            $0.leading(to: nameTextField)
            $0.width(to: heightTextLayoutInch)
        }
        
        heightTextLayoutInch.run {
            $0.centerY(to: heightLabel)
            $0.leadingToTrailing(of: heightTextLayoutFeet, offset: 8)
            $0.trailingToLeading(of: lengthConversionLabel, offset: -10)
        }
        
        heightTextLayoutMetric.run {
            $0.centerY(to: heightLabel)
            $0.leading(to: nameTextField)
            $0.trailingToLeading(of: lengthConversionLabel, offset: -10)
        }
        
        lengthConversionLabel.run {
            $0.centerY(to: heightLabel)
            $0.setContentHuggingPriority(.required, for: .horizontal)
            $0.trailingToSuperview()
        }
        
        genderLabel.run {
            $0.topToBottom(of: heightLabel, offset: 24)
            $0.leadingToSuperview()
        }
        
        genderStackView.run {
            $0.centerY(to: genderLabel)
            $0.leading(to: nameTextField)
            $0.trailingToSuperview()
        }
        
        birthDateLabel.run {
            $0.topToBottom(of: genderLabel, offset: 24)
            $0.leadingToSuperview()
        }
        
        dateTextField.run {
            $0.centerY(to: birthDateLabel)
            $0.leading(to: nameTextField)
            $0.trailingToSuperview()
            $0.bottomToSuperview(offset: -4)
        }
    }
    
    private func setInteractions() {
        radioButtons.forEach { $0.onTap(target: self, action: #selector(onRadioButtonTap)) }
        lengthConversionLabel.onTap(target: self, action: #selector(changeLengthConversion))
    }
    
    @objc private func onRadioButtonTap(recognizer: UITapGestureRecognizer) {
        radioButtons.forEach { $0.deselect() }
        (recognizer.view as! RadioButtonOption).select()
    }
    
    @objc private func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter().apply {
            $0.dateFormat = "dd/MM/YYYY"
        }
        dateTextField.text = dateFormatter.string(from: sender.date)
    }
    
    @objc private func onDoneTap() {
        dateTextField.resignFirstResponder()
    }

    @objc private func changeLengthConversion() {
        switch(lengthConversionType) {
        case .imperial:
            lengthConversionType = .metric
        case .metric:
            lengthConversionType = .imperial
        }
    }
    
    private func updateUI() {
        switch(lengthConversionType) {
        case .imperial:
            lengthConversionLabel.text = "imperial".localized
            heightTextLayoutFeet.isHidden = false
            heightTextLayoutInch.isHidden = false
            heightTextLayoutMetric.isHidden = true
        case .metric:
            lengthConversionLabel.text = "metric".localized
            heightTextLayoutFeet.isHidden = true
            heightTextLayoutInch.isHidden = true
            heightTextLayoutMetric.isHidden = false
        }
    }
    
    func getUserUpdateData() -> UserUpdateData? {
        if !isValidData() {
            store.dispatch(action: MessageAction().apply { $0.message = "some_fields_are_empty".localized })
            return nil
        }
        
        return UserUpdateData(
            fullName: getName(),
            birthdate: getBirthdate(),
            height: getHeight(),
            gender: getGender()
        )
    }
    
    private func isValidData() -> Bool {
        if lengthConversionType == .metric && heightTextLayoutMetric.textField.text == "" ||
            lengthConversionType == .imperial && (heightTextLayoutFeet.textField.text == "" || heightTextLayoutInch.textField.text == "") {
            return false
        }
        return nameTextField.text != "" && dateTextField.text != ""
    }
    
    private func getName() -> String {
        return nameTextField.text ?? ""
    }
    
    private func getBirthdate() -> Int64 {
        return Int64((dateTextField.inputView as! UIDatePicker).date.timeIntervalSince1970 * 1000)
    }
    
    private func getHeight() -> Int32 {
        if lengthConversionType == .metric {
            return Int32(heightTextLayoutMetric.textField.text ?? "")!
        } else {
            let feet = Double(heightTextLayoutFeet.textField.text ?? "")!
            let inch = Double(heightTextLayoutInch.textField.text ?? "")!
            return Int32(round(feet * 30.48 + inch * 2.54))
        }
    }
    
    private func getGender() -> Gender {
        guard let button = radioButtons.first(where: { $0.isSelected }) else { fatalError() }
        return (button.value as! Gender)
    }
}
