//
//  RadioButtonOption.swift
//  Asthm App
//
//  Created by Den Matiash on 11.02.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation
import UIKit

class RadioButtonOption: UIView {
    
    private let label = LinkLabel().apply {
        $0.textColor = Palette.white
    }
    private let circleView = UIView().apply {
        $0.layer.run {
            $0.borderWidth = 1
            $0.cornerRadius = 5
        }
    }
    
    private(set) var value: Any = 0
    private(set) var isSelected = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        buildViewTree()
        setConstraints()
        deselect()
    }
    
    private func buildViewTree() {
        addSubview(label)
        addSubview(circleView)
    }
    
    private func setConstraints() {
        label.run {
            $0.leadingToSuperview()
            $0.centerY(to: circleView)
        }
        
        circleView.run {
            $0.width(10)
            $0.height(10)
            $0.leadingToTrailing(of: label, offset: 6)
            $0.verticalToSuperview(insets: .vertical(10))
            $0.trailingToSuperview()
        }
    }
    
    func select() {
        isSelected = true
        circleView.backgroundColor = Palette.ebonyClay
        circleView.layer.borderColor = Palette.white.cgColor
    }
    
    func deselect() {
        isSelected = false
        circleView.backgroundColor = .clear
        circleView.layer.borderColor = Palette.ebonyClay.cgColor
    }
    
    func bind(_ text: String, _ value: Any) {
        label.text = text
        self.value = value
    }
}
