//
//  CounterView.swift
//  Asthm App
//
//  Created by Den Matiash on 17.01.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation
import UIKit
import MaterialComponents.MDCButton
import common

class CounterView: UIView {
    
    private let minusButton = MDCFloatingButton().apply {
        $0.backgroundColor = Palette.white
        $0.tintColor = Palette.royalBlue
        $0.setImage(UIImage(named: "ic_minus")?.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.setElevation(ShadowElevation(rawValue: 1), for: .normal)
        $0.setElevation(ShadowElevation(rawValue: 3), for: .highlighted)
    }
    
    private let label = BigBodyLabel().apply {
        $0.textColor = Palette.royalBlue
        $0.textAlignment = .center
    }
    
    private let plusButton = MDCFloatingButton().apply {
        $0.backgroundColor = Palette.white
        $0.tintColor = Palette.royalBlue
        $0.setImage(UIImage(named: "ic_plus")?.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.setElevation(ShadowElevation(rawValue: 1), for: .normal)
        $0.setElevation(ShadowElevation(rawValue: 3), for: .highlighted)
    }
    
    private var value: Int32 = 0
    private var onDataChange: (Int32) -> () = { _ in }
    private var validator: IValueValidator? = nil
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    private func setupView() {
        layer.run {
            $0.cornerRadius = 8
            $0.masksToBounds = true
        }
        backgroundColor = Palette.solitude
        buildViewTree()
        setConstraints()
        setInteractions()
    }
    
    private func buildViewTree() {
        [minusButton, label, plusButton].forEach(addSubview)
    }
    
    private func setConstraints() {
        minusButton.run {
            $0.width(30)
            $0.height(30)
            $0.centerYToSuperview()
            $0.leadingToSuperview(offset: 6)
        }
        
        label.run {
            $0.verticalToSuperview(insets: .vertical(10))
            $0.centerXToSuperview()
        }
        
        plusButton.run {
            $0.width(30)
            $0.height(30)
            $0.centerYToSuperview()
            $0.trailingToSuperview(offset: 6)
        }
    }
    
    private func setInteractions() {
        minusButton.addTarget(self, action: #selector(minusTapped), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(plusTapped), for: .touchUpInside)
    }
    
    @objc private func minusTapped() {
        if validator?.isValid(value: String(value - 1)) ?? true {
            value -= 1
            onDataChange(value)
            label.text = "\(value)"
        }
    }
    
    @objc private func plusTapped() {
        if validator?.isValid(value: String(value + 1)) ?? true {
            value += 1
            onDataChange(value)
            label.text = "\(value)"
        }
    }
    
    func bind(_ item: AddDataItem.PuffsUIModel.Item) {
        onDataChange = item.onDataChange
        validator = item.validator
        value = item.value
        label.text = "\(item.value)"
    }
}
