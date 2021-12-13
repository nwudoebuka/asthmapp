//
//  AverageDataCardView.swift
//  Asthm App
//
//  Created by Den Matiash on 20.01.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation
import UIKit

class AverageDataCardView: CardView {
    
    private let imageView = UIImageView()
    private let smallImageView = UIImageView()
    private let titleLabel = BigHeaderBoldLabel()
    private let measureUnitLabel = HintLabel().apply {
        $0.textColor = Palette.ebonyClay
    }
    private let subtitleLabel = HintLabel()
    
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
        [imageView, smallImageView, titleLabel, measureUnitLabel, subtitleLabel].forEach(addSubview)
    }
    
    private func setConstraints() {
        imageView.run {
            $0.topToSuperview(offset: 12)
            $0.leadingToSuperview(offset: 12)
            $0.width(32)
            $0.height(32)
        }
        
        smallImageView.run {
            $0.leadingToSuperview(offset: 34)
            $0.topToSuperview(offset: 8)
            $0.width(16)
            $0.height(16)
        }
        
        titleLabel.run {
            $0.leadingToTrailing(of: smallImageView, offset: 8)
            $0.centerY(to: imageView)
        }
        
        measureUnitLabel.run {
            $0.leadingToTrailing(of: titleLabel)
            $0.bottom(to: titleLabel, offset: -2.5)
        }
        
        subtitleLabel.run {
            $0.topToBottom(of: titleLabel, offset: 4)
            $0.leading(to: titleLabel)
            $0.trailingToSuperview(offset: 12)
            $0.bottomToSuperview(offset: -12)
        }
    }
    
    struct UIModel {
        let image: UIImage?
        let smallImage: UIImage?
        let title: String
        let subtitle: String
        let measureUnit: String?
    }
    
    func bind(_ item: UIModel) {
        imageView.image = item.image
        smallImageView.image = item.smallImage
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
        measureUnitLabel.text = item.measureUnit
    }
}
