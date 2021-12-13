//
//  ReportItemView.swift
//  Asthm App
//
//  Created by Den Matiash on 28.01.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation
import UIKit

class ReportItemView: UIView {
    
    private let titleLabel = BigBodyLabel()
    private let subtitleLabel = BodyLabel().apply {
        $0.textColor = Palette.slateGray
    }
    private let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        buildViewTree()
        setConstraints()
    }
    
    private func buildViewTree() {
        [titleLabel, subtitleLabel, imageView].forEach(addSubview)
    }
    
    private func setConstraints() {
        titleLabel.run {
            $0.topToSuperview(offset: 6)
            $0.leadingToSuperview()
        }
        
        subtitleLabel.run {
            $0.topToBottom(of: titleLabel, offset: 2)
            $0.leadingToSuperview()
            $0.bottomToSuperview(offset: -6)
        }
        
        imageView.run {
            $0.width(40)
            $0.height(40)
            $0.trailingToSuperview()
            $0.centerYToSuperview()
        }
    }
    
    func bind(_ item: ReportsItem.ReportUIModel.Item) {
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
        imageView.image = item.image
    }
}
