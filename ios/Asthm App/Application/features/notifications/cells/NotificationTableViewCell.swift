//
//  NotificationTableViewCell.swift
//  Asthm App
//
//  Created by Den Matiash on 03.01.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation
import UIKit
import TinyConstraints

class NotificationTableViewCell: UITableViewCell {
    
    private let cardView = CardView()
    private let iconView = UIImageView(image: UIImage(named: "ic_heart"))
    private let messageLabel = BodyLabel()
    private let leftButton = CommonMaterialButton()
    private let rightButton = CommonMaterialButton()
    private var onLeftButtonTap: () -> () = { }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
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
        [iconView, messageLabel, leftButton, rightButton].forEach { cardView.addSubview($0) }
    }
    
    private func setConstraints() {
        cardView.edgesToSuperview(insets: UIEdgeInsets(top: 6, left: 16, bottom: 6, right: 16))
        iconView.run {
            $0.width(32)
            $0.height(32)
            $0.centerY(to: messageLabel)
            $0.leadingToSuperview(offset: 12)
        }
        messageLabel.run {
            $0.topToSuperview(offset: 12)
            $0.leadingToTrailing(of: iconView, offset: 8)
            $0.trailingToSuperview(offset: 4)
        }
        leftButton.run {
            $0.leading(to: messageLabel)
            $0.topToBottom(of: messageLabel, offset: 12)
            $0.bottomToSuperview(offset: -12)
        }
        rightButton.run {
            $0.top(to: leftButton)
            $0.leadingToTrailing(of: leftButton, offset: 12)
        }
    }
    
    private func setInteractions() {
        leftButton.onTap(target: self, action: #selector(onLeftButtonClick))
    }
    
    @objc private func onLeftButtonClick() {
        onLeftButtonTap()
    }
    
    func bind(_ notificationItem: NotificationItem.Notification, onLeftButtonTap: @escaping () -> ()) {
        let text = notificationItem.message.attributed.apply {
            $0.append(" ".attributed)
            $0.append(notificationItem.time.colorString(color: Palette.slateGray))
        }
        self.onLeftButtonTap = onLeftButtonTap
        messageLabel.attributedText = text
        
        switch (notificationItem.type) {
        case .question:
            leftButton.setTitle("yes".localized, for: .normal)
            rightButton.isHidden = false
            rightButton.setTitle("no".localized, for: .normal)
        case .addData:
            leftButton.setTitle("plus_add_data".localized, for: .normal)
            rightButton.isHidden = true
        case .learnMore:
            leftButton.setTitle("learn_more".localized, for: .normal)
            rightButton.isHidden = true
        case .shop:
            leftButton.setTitle("shop".localized, for: .normal)
            rightButton.isHidden = true
        case .info:
            leftButton.isHidden = true
            rightButton.isHidden = true
        default:
            break
        }
    }
}
