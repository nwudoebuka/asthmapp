//
//  ViewReportsCardView.swift
//  Asthm App
//
//  Created by Den Matiash on 08.02.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation
import UIKit

class ViewReportsCardView: CardView {
    
    private let titleLabel = BigBodyBoldLabel().apply {
        $0.text = "view_reports".localized
        $0.textAlignment = .center
    }
    private let containerView = UIView()
    private let subtitleLabel = BodyLabel().apply {
        $0.textColor = Palette.royalBlue
        $0.text = "new_records".localized
    }
    private let chevronIcon = UIImageView(image: UIImage(named: "ic_chevron_right")?.withRenderingMode(.alwaysTemplate)).apply {
        $0.tintColor = Palette.royalBlue
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        buildViewTree()
        setConstraints()
    }
    
    private func buildViewTree() {
        [titleLabel, containerView].forEach(addSubview)
        [subtitleLabel, chevronIcon].forEach(containerView.addSubview)
    }
    
    private func setConstraints() {
        titleLabel.run {
            $0.horizontalToSuperview(insets: .horizontal(12))
            $0.centerYToSuperview(offset: -8)
        }
        containerView.run {
            $0.topToBottom(of: titleLabel)
            $0.centerXToSuperview()
            $0.bottomToSuperview()
        }
        subtitleLabel.run {
            $0.verticalToSuperview(insets: .vertical(4))
            $0.leadingToSuperview()
        }
        chevronIcon.run {
            $0.width(20)
            $0.height(20)
            $0.leadingToTrailing(of: subtitleLabel)
            $0.centerYToSuperview()
            $0.trailingToSuperview()
        }
    }
}
