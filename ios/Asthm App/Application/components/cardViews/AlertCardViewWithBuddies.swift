//
//  AlertCardViewWithBuddies.swift
//  Asthm App
//
//  Created by Den Matiash on 05.02.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation
import UIKit
import common
import Lottie

class AlertCardViewWithBuddies: CardView {
    
    private let numberLabel = BigBodyLabel().apply {
        $0.textColor = Palette.white
    }
    private let circleView = CircleImageView().apply {
        $0.backgroundColor = Palette.ebonyClay
    }
    private let animationView = AnimationView(name: "pulsing_circle")
    private let label = BigBodyLabel()
    private let stackView = UIStackView().apply {
        $0.axis = .vertical
        $0.spacing = 8
        $0.distribution = .equalSpacing
    }
    private let buddiesSpacing = CGFloat(8)
    private let cardHorizontalInsets = CGFloat(16)
    private let stackViewHorizontalInsets = CGFloat(12)
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = Palette.brightBlack
        layer.borderWidth = 2
        
        buildViewTree()
        setConstraints()
        animationView.play(fromProgress: 0, toProgress: 1, loopMode: .loop)
    }
    
    private func buildViewTree() {
        [animationView, circleView, numberLabel, label, stackView].forEach(addSubview)
    }
    
    private func setConstraints() {
        animationView.run {
            $0.width(50)
            $0.height(50)
            $0.center(in: circleView)
        }
        circleView.run {
            $0.leadingToSuperview(offset: 12)
            $0.width(32)
            $0.height(32)
            $0.centerY(to: label)
        }
        numberLabel.center(in: circleView)
        label.run {
            $0.topToSuperview(offset: 16)
            $0.leadingToTrailing(of: circleView, offset: 12)
            $0.trailingToSuperview(offset: 12)
        }
        stackView.run {
            $0.topToBottom(of: label, offset: 12)
            $0.bottomToSuperview(offset: -12)
            $0.horizontalToSuperview(insets: .horizontal(stackViewHorizontalInsets))
        }
    }
    
    struct UIModel {
        let number: Int
        let text: String
        let alertStatus: AlertStatus
        let buddies: [Buddy]
    }
    
    func bind(_ uiModel: UIModel) {
        numberLabel.text = "\(uiModel.number)"
        label.text = uiModel.text
        
        switch(uiModel.alertStatus) {
        case .past:
            animationView.isHidden = true
            circleView.isHidden = false
            
            label.textColor = Palette.white
            layer.borderColor = Palette.darkturquoise.cgColor
        case .active:
            animationView.isHidden = false
            circleView.isHidden = true
            
            label.textColor = Palette.white
            layer.borderColor = Palette.indigo.cgColor
        case .future:
            animationView.isHidden = true
            circleView.isHidden = false
            
            label.textColor = Palette.white.withAlphaComponent(0.5)
            layer.borderColor = nil
        default:
            break
        }
        
        resetBuddies()
        addBuddies(uiModel.buddies)
    }
    
    private func resetBuddies() {
        stackView.arrangedSubviews.forEach { rowStackView in
            (rowStackView as! UIStackView).arrangedSubviews.forEach { $0.removeFromSuperview() }
            rowStackView.removeFromSuperview()
        }
    }
    
    private func addBuddies(_ buddies: [Buddy]) {
        var widthOfCurrentRow = CGFloat(0)
        var currentRowStackView = addNewRow()
        
        buddies.enumerated().forEach { index, buddy in
            let cellWidth = buddy.fullName.size(
                withAttributes: [.font: UIFont.systemFont(ofSize: 14.0)]
            ).width + 24 + 16 + 4 + 2
            
            if widthOfCurrentRow + cellWidth + buddiesSpacing < UIScreen.main.bounds.width - 2 * (cardHorizontalInsets + stackViewHorizontalInsets) {
                widthOfCurrentRow += cellWidth + buddiesSpacing
            } else {
                widthOfCurrentRow = cellWidth + buddiesSpacing
                currentRowStackView.addArrangedSubview(buildSpacer())
                currentRowStackView = addNewRow()
            }
            currentRowStackView.addArrangedSubview(buildBuddyView(buddy, index))
        }
        
        currentRowStackView.addArrangedSubview(buildSpacer())
    }
    
    private func addNewRow() -> UIStackView {
        let rowStackView = UIStackView().apply {
            $0.axis = .horizontal
            $0.spacing = buddiesSpacing
            $0.distribution = .fill
        }
        stackView.addArrangedSubview(rowStackView)
        return rowStackView
    }
    
    private func buildBuddyView(_ buddy: Buddy, _ index: Int) -> BuddyView {
        let uiModel = BuddyView.UIModel(
            image: getImageFromBase64(buddy.avatar),
            name: buddy.fullName,
            textColor: Palette.white,
            backgroundColor: Palette.ebonyClay,
            borderColor: nil
        )
        return BuddyView().apply {
            $0.tag = index
            $0.bind(uiModel)
        }
    }
    
    private func buildSpacer() -> UIView {
        UIView().apply { $0.setContentHuggingPriority(.defaultLow, for: .horizontal) }
    }
    
    private func getImageFromBase64(_ base64String: String?) -> UIImage? {
        guard let base64String = base64String else { return nil }
        guard let imageData = Data(base64Encoded: base64String) else { return nil }
        return UIImage(data: imageData)
    }
}
