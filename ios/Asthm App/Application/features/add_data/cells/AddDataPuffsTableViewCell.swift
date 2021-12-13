//
//  AddDataPuffsTableViewCell.swift
//  Asthm App
//
//  Created by Den Matiash on 17.01.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation
import UIKit

class AddDataPuffsTableViewCell: UITableViewCell {
    
    private let cardView = CardView()
    private let titleLabel = BigBodyBoldLabel()
    private let additionalView = UIView()
    private let hintLabel = LinkLabel().apply {
        $0.textColor = Palette.slateGray
        $0.attributedText = "how_it_works".localized.underlined
    }
    private let horizontalLine = UIView().apply {
        $0.backgroundColor = Palette.slateGray
        $0.alpha = 0.1
    }
    private let stackView = UIStackView().apply {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
    }
    
    private var onHintTap: () -> () = { }
    
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
        contentView.addSubview(cardView)
        [titleLabel, additionalView, hintLabel, horizontalLine, stackView].forEach(cardView.addSubview)
    }
    
    private func setConstraints() {
        cardView.edgesToSuperview(insets: UIEdgeInsets(top: 6, left: 16, bottom: 6, right: 16))
        titleLabel.run {
            $0.leadingToSuperview(offset: 12)
            $0.topToSuperview(offset: 16)
        }
        horizontalLine.run {
            $0.topToBottom(of: titleLabel, offset: 10)
            $0.horizontalToSuperview(insets: .horizontal(12))
            $0.height(1)
        }
        additionalView.run {
            $0.topToSuperview()
            $0.bottom(to: horizontalLine)
        }
        hintLabel.run {
            $0.centerY(to: additionalView)
            $0.trailingToSuperview(offset: 12)
        }
        stackView.run {
            $0.top(to: horizontalLine, offset: 4)
            $0.horizontalToSuperview(insets: .horizontal(12))
            $0.bottomToSuperview(offset: -4)
        }
    }
    
    private func setInteractions() {
        hintLabel.onTap(target: self, action: #selector(onHintLabelTap))
    }
    
    @objc private func onHintLabelTap() {
        onHintTap()
    }
    
    func bind(_ uiModel: AddDataItem.PuffsUIModel, _ onHintTap: @escaping () -> ()) {
        titleLabel.text = uiModel.title
        self.onHintTap = onHintTap
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        uiModel.items.forEach { item in
            let itemView = PuffsItemView().apply {
                $0.bind(item)
            }
            stackView.addArrangedSubview(itemView)
        }
    }
}
