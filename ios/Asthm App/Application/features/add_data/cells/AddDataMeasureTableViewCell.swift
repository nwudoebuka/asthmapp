//
//  AddDataMeasureTableViewCell.swift
//  Asthm App
//
//  Created by Den Matiash on 16.01.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation
import UIKit
import TinyConstraints

class AddDataMeasureTableViewCell: UITableViewCell {

    private let cardView = CardView()
    private let titleLabel = BigBodyBoldLabel().apply {
        $0.lineBreakMode = .byTruncatingTail
    }
    private let textField = TextFieldWithRightView()
    private let linkLabel = LinkLabel().apply {
        $0.textColor = Palette.slateGray
    }
    private var onHintTap: () -> () = {}
    
    private var centerConstraint: Constraint?

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
        [titleLabel, textField, linkLabel].forEach(cardView.addSubview)
    }

    private func setConstraints() {
        cardView.height(min: 72)
        cardView.edgesToSuperview(insets: UIEdgeInsets(top: 6, left: 16, bottom: 6, right: 16))
        titleLabel.run {
            $0.leadingToSuperview(offset: 12)
            $0.topToSuperview(offset: 20)
            centerConstraint = $0.centerYToSuperview().apply { $0.isActive = false }
            $0.trailingToLeading(of: textField, offset: -12)
        }
        linkLabel.run {
            $0.leadingToSuperview(offset: 12)
            $0.topToBottom(of: titleLabel, offset: 4)
            $0.bottomToSuperview(offset: -16)
        }
        textField.run {
            $0.topToSuperview(offset: 16)
            $0.trailingToSuperview(offset: 12)
        }
    }

    private func setInteractions() {
        linkLabel.onTap(target: self, action: #selector(onHintLabelTap))
    }

    @objc private func onHintLabelTap() {
        onHintTap()
    }

    func bind(_ uiModel: AddDataItem.MeasureUIModel, _ onHintTap: @escaping () -> ()) {
        titleLabel.text = uiModel.title
        textField.bind(uiModel)
        centerConstraint?.isActive = uiModel.linkText == nil
        linkLabel.isHidden = uiModel.linkTitle == nil
        linkLabel.attributedText = uiModel.linkTitle?.underlined
        self.onHintTap = onHintTap
    }
}
