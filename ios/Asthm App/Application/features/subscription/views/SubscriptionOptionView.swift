//
//  SubscriptionOptionView.swift
//  Asthm App
//
//  Created by Den Matiash on 23.02.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation
import UIKit

class SubscriptionOptionView: UIView {

    let content = UIView()

    let progress = UIActivityIndicatorView().apply {
        $0.color = Palette.royalBlue
        $0.startAnimating()
    }
    
    private let blueView = UIView().apply {
        $0.backgroundColor = Palette.royalBlue
        $0.layer.cornerRadius = 14
    }
    
    private let titleLabel = BigBodyLabel().apply {
        $0.textColor = Palette.white
        $0.textAlignment = .center
        $0.text = "standard".localized
    }
    
    private let containerView = UIView()
    
    private let currencyLabel = BigBodyLabel().apply {
        $0.textColor = Palette.royalBlue
    }
    
    private let priceLabel = BigHeaderBoldLabel().apply {
        $0.textColor = Palette.royalBlue
        $0.backgroundColor = .clear
    }
    
    private let periodLabel = BigBodyBoldLabel().apply {
        $0.text = "per_month".localized
        $0.textColor = Palette.royalBlue
    }
    
    private let checkmarkView = UIImageView(image: UIImage(named: "ic_subscription_checkmark"))
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    private func setupView() {
        backgroundColor = Palette.white
        layer.run {
            $0.borderWidth = 3
            $0.cornerRadius = 20
            $0.borderColor = Palette.royalBlue.cgColor
            
            $0.shadowColor = Palette.black.cgColor
            $0.shadowOffset = CGSize(width: 0.0, height: 3.0)
            $0.shadowOpacity = 0.25
            $0.shadowRadius = 1
        }
        buildViewTree()
        setConstraints()
    }

    private func buildViewTree() {
        [content, progress].forEach(addSubview)

        [blueView, containerView, checkmarkView].forEach(content.addSubview)
        
        containerView.addSubview(currencyLabel)
        containerView.addSubview(priceLabel)
        containerView.addSubview(periodLabel)
        
        blueView.addSubview(titleLabel)
    }
    
    private func setConstraints() {
        content.edgesToSuperview()
        progress.centerInSuperview()
        
        blueView.run {
            $0.edgesToSuperview(excluding: .bottom, insets: .uniform(8))
            $0.height(28)
        }
        titleLabel.edgesToSuperview()
    
        containerView.centerInSuperview()
        currencyLabel.run {
            $0.topToSuperview()
            $0.leadingToSuperview()
        }
        priceLabel.run {
            $0.leadingToTrailing(of: currencyLabel, offset: 2)
            $0.verticalToSuperview()
        }
        periodLabel.run {
            $0.leadingToTrailing(of: priceLabel, offset: 2)
            $0.trailingToSuperview()
            $0.bottomToSuperview(offset: -1.8)
        }
        checkmarkView.run {
            $0.width(50)
            $0.height(50)
            $0.trailingToSuperview(offset: -4)
            $0.bottomToSuperview(offset: 4)
        }
    }
    
    func bind(_ currency: String, _ price: String) {
        currencyLabel.text = currency
        priceLabel.text = price
    }
}
