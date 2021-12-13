//
//  HomeAdCollectionViewCell.swift
//  Asthm App
//
//  Created by Den Matiash on 26.01.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation
import UIKit

class HomeAdCollectionViewCell: UICollectionViewCell {
    
    private let cardView = CardView()
    private let photoView = UIImageView().apply {
        $0.layer.run {
            $0.cornerRadius = 10
            $0.borderWidth = 1
            $0.borderColor = Palette.slateGray.withAlphaComponent(0.1).cgColor
            $0.masksToBounds = true
        }
        $0.contentMode = .scaleAspectFill
    }
    private let containerView = UIView()
    private let titleLabel = BodyLabel()
    private let oldPriceLabel = BodyLabel()
    private let newPriceLabel = BodyLabel().apply {
        $0.textColor = Palette.royalBlue
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = .clear
        
        buildViewTree()
        setConstraints()
    }
    
    private func buildViewTree() {
        addSubview(cardView)
        [photoView, containerView].forEach(cardView.addSubview)
        [titleLabel, oldPriceLabel, newPriceLabel].forEach(containerView.addSubview)
    }
    
    private func setConstraints() {
        cardView.edgesToSuperview()
        
        photoView.run {
            $0.width(84)
            $0.height(84)
            $0.leadingToSuperview(offset: 12)
            $0.verticalToSuperview(insets: .vertical(12))
        }
        
        containerView.run {
            $0.leadingToTrailing(of: photoView, offset: 12)
            $0.trailingToSuperview(offset: 12)
            $0.centerY(to: photoView)
        }
        
        titleLabel.run {
            $0.topToSuperview()
            $0.leadingToSuperview()
            $0.trailingToSuperview()
        }
        
        oldPriceLabel.run {
            $0.topToBottom(of: titleLabel, offset: 4)
            $0.leadingToSuperview()
            $0.bottomToSuperview()
        }
        
        newPriceLabel.run {
            $0.top(to: oldPriceLabel)
            $0.leadingToTrailing(of: oldPriceLabel, offset: 4)
        }
    }
    
    struct UIModel {
        let imagePath: String
        let title: String
        let oldPrice: String
        let newPrice: String
        let link: String
    }
    
    func bind(_ item: UIModel) {
        photoView.sd_setImage(with: URL(string: item.imagePath))
        titleLabel.text = item.title
        oldPriceLabel.attributedText = item.oldPrice.crossed
        newPriceLabel.text = item.newPrice
    }
}
