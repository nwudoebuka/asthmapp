//
//  ReportTableViewCell.swift
//  Asthm App
//
//  Created by Den Matiash on 28.01.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation
import UIKit

class ReportTableViewCell: UITableViewCell {
    
    private let cardView = CardView()
    private let titleLabel = BigBodyBoldLabel()
    private let additionalView = UIView()
    private let shareButton = CommonMaterialButton().apply {
        $0.setTitle("share".localized, for: .normal)
        $0.setImage(UIImage(named: "ic_share"), for: .normal)
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: -14, bottom: 0, right: 0)
    }
    private let horizontalLine = UIView().apply {
        $0.backgroundColor = Palette.slateGray
        $0.alpha = 0.1
    }
    private let stackView = UIStackView().apply {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.spacing = 4
    }
    
    private var onShareTap: () -> () = { }
    
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
        [titleLabel, additionalView, shareButton, horizontalLine, stackView].forEach(cardView.addSubview)
    }
    
    private func setConstraints() {
        cardView.edgesToSuperview(insets: UIEdgeInsets(top: 6, left: 16, bottom: 6, right: 16))
        titleLabel.run {
            $0.leadingToSuperview(offset: 12)
            $0.topToSuperview(offset: 24)
        }
        horizontalLine.run {
            $0.topToBottom(of: titleLabel, offset: 16)
            $0.horizontalToSuperview(insets: .horizontal(12))
            $0.height(1)
        }
        additionalView.run {
            $0.topToSuperview()
            $0.bottom(to: horizontalLine)
        }
        shareButton.run {
            $0.centerY(to: additionalView)
            $0.trailingToSuperview(offset: 12)
        }
        stackView.run {
            $0.top(to: horizontalLine, offset: 6)
            $0.horizontalToSuperview(insets: .horizontal(12))
            $0.bottomToSuperview(offset: -6)
        }
    }
    
    private func setInteractions() {
        shareButton.onTap(target: self, action: #selector(onShareClick))
    }
    
    @objc private func onShareClick() {
        onShareTap()
    }
    
    func bind(_ uiModel: ReportsItem.ReportUIModel) {
        titleLabel.text = uiModel.title
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        uiModel.items.forEach { item in
            let itemView = ReportItemView().apply {
                $0.bind(item)
            }
            stackView.addArrangedSubview(itemView)
        }
        shareButton.isHidden = !uiModel.isShareEnabled
        self.onShareTap = uiModel.onShareTap
    }
}
