//
//  AddDataNextReviewTableViewCell.swift
//  Asthm App
//
//  Created by Den Matiash on 17.01.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation
import UIKit

class AddDataNextReviewTableViewCell: UITableViewCell {

    private let cardView = CardView()
    private let titleLabel = BigBodyBoldLabel()
    private let subtitleLabel = BodyLabel().apply {
        $0.text = "choose_date_and_time".localized
        $0.textColor = Palette.royalBlue
    }
    private let horizontalLine = UIView().apply {
        $0.backgroundColor = Palette.slateGray
        $0.alpha = 0.1
    }
    private let reminderLabel = BodyLabel().apply {
        $0.textColor = Palette.ebonyClay
        $0.text = "reminder".localized
    }
    private let hintLabel = LinkLabel().apply {
        $0.lineBreakMode = .byTruncatingTail
        $0.numberOfLines = 1
        $0.textColor = Palette.slateGray
        $0.text = "reminder_explanation".localized
    }
    private let additionalView = UIView()
    private let switchView = UISwitch()
    
    private let datePicker = UIDatePicker().apply {
        $0.datePickerMode = .dateAndTime
        $0.backgroundColor = Palette.white
    }
    private let additionalView2 = UIView()
    private lazy var dateTextField = UITextField().apply {
        $0.textColor = Palette.slateGray
        $0.font = Font.body
        $0.inputView = datePicker
        $0.inputAccessoryView = UIToolbar().apply {
            $0.sizeToFit()
            $0.barTintColor = Palette.white
            $0.items = [
                UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
                UIBarButtonItem(title: "done".localized, style: .plain, target: self, action: #selector(onDoneTap))
            ]
        }
        $0.textAlignment = .right
        $0.tintColor = .clear
    }

    private var onReminderSwitch: (Bool) -> () = { _ in }
    private var onScheduledReminderSet: (Int64) -> () = { _ in }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        selectionStyle = .none
        backgroundColor = .clear

        buildViewTree()
        setConstraints()
        setInteractions()
    }

    private func buildViewTree() {
        addSubview(cardView)
        [titleLabel, subtitleLabel, additionalView2, dateTextField, horizontalLine, reminderLabel, hintLabel, additionalView, switchView].forEach(cardView.addSubview)
    }

    private func setConstraints() {
        cardView.edgesToSuperview(insets: UIEdgeInsets(top: 6, left: 16, bottom: 6, right: 16))
        additionalView2.run {
            $0.topToSuperview()
            $0.bottomToTop(of: horizontalLine)
        }
        titleLabel.run {
            $0.leadingToSuperview(offset: 12)
            $0.topToSuperview(offset: 16)
        }
        subtitleLabel.run {
            $0.leadingToSuperview(offset: 12)
            $0.topToBottom(of: titleLabel, offset: 4)
        }
        dateTextField.run {
            $0.leadingToSuperview()
            $0.trailingToSuperview(offset: 12)
            $0.centerY(to: additionalView2)
        }
        horizontalLine.run {
            $0.topToBottom(of: subtitleLabel, offset: 10)
            $0.horizontalToSuperview(insets: .horizontal(12))
            $0.height(1)
        }
        reminderLabel.run {
            $0.topToBottom(of: horizontalLine, offset: 10)
            $0.leadingToSuperview(offset: 12)
        }
        hintLabel.run {
            $0.topToBottom(of: reminderLabel, offset: 4)
            $0.leadingToSuperview(offset: 12)
            $0.trailingToLeading(of: switchView, offset: -8)
            $0.bottomToSuperview(offset: -16)
        }
        additionalView.run {
            $0.topToBottom(of: horizontalLine)
            $0.bottomToSuperview()
        }
        switchView.run {
            $0.centerY(to: additionalView)
            $0.trailingToSuperview(offset: 12)
        }
    }

    private func setInteractions() {
        switchView.addTarget(self, action: #selector(switchTrigger), for: .valueChanged)
        subtitleLabel.onTap(target: self, action: #selector(onSubtitleTap))
        datePicker.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
    }

    @objc private func switchTrigger() {
        onReminderSwitch(switchView.isOn)
    }
    
    @objc private func onSubtitleTap() {
        dateTextField.becomeFirstResponder()
    }
    
    @objc private func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter().apply {
            $0.dateFormat = "yyyy-MM-dd HH:mm"
        }
        dateTextField.text = dateFormatter.string(from: sender.date)
        onScheduledReminderSet(Int64(sender.date.timeIntervalSince1970 * 1000))
    }
    
    @objc private func onDoneTap() {
        dateTextField.resignFirstResponder()
    }

    func bind(_ uiModel: AddDataItem.NextReviewUIModel) {
        titleLabel.text = uiModel.title
        onReminderSwitch = uiModel.onReminderSwitch
        switchView.isOn = uiModel.isReminderActivated
        onScheduledReminderSet = uiModel.onScheduledReminderSet
    }
}
