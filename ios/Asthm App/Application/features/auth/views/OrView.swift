//
//  OrView.swift
//  Asthm App
//
//  Created by Den Matiash on 25.01.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation
import UIKit

class OrView: UIView {
    
    private let leftLine = UIView().apply {
        $0.backgroundColor = Palette.slateGray
    }
    private let orLabel = SmallHeaderLabel().apply {
        $0.text = "or".localized.uppercased()
        $0.textColor = Palette.slateGray
    }
    private let rightLine = UIView().apply {
        $0.backgroundColor = Palette.slateGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    private func setupView() {
        addSubview(leftLine)
        addSubview(orLabel)
        addSubview(rightLine)
        
        leftLine.run {
            $0.height(1)
            $0.width(38)
            $0.leadingToSuperview()
            $0.centerY(to: orLabel)
        }
        
        orLabel.run {
            $0.leadingToTrailing(of: leftLine, offset: 4)
            $0.verticalToSuperview()
        }
        
        rightLine.run {
            $0.height(1)
            $0.leadingToTrailing(of: orLabel, offset: 4)
            $0.width(38)
            $0.trailingToSuperview()
            $0.centerY(to: orLabel)
        }
    }
}
