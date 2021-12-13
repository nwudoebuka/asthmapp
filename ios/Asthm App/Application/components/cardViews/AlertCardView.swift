//
//  AlertCardView.swift
//  Asthm App
//
//  Created by Den Matiash on 05.02.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation
import UIKit
import common
import Lottie

class AlertCardView: CardView {
    
    private let numberLabel = BigBodyLabel().apply {
        $0.textColor = Palette.white
    }
    private let circleView = CircleImageView().apply {
        $0.backgroundColor = Palette.ebonyClay
    }
    private let animationView = AnimationView(name: "pulsing_circle")
    private let label = BigBodyLabel()
    
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
        [animationView, circleView, numberLabel, label].forEach(addSubview)
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
            $0.centerYToSuperview()
        }
        numberLabel.center(in: circleView)
        label.run {
            $0.verticalToSuperview(insets: .vertical(16))
            $0.leadingToTrailing(of: circleView, offset: 12)
            $0.trailingToSuperview(offset: 12)
        }
    }
    
    struct UIModel {
        let number: Int
        let text: String
        let alertStatus: AlertStatus
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
    }
}
