//
//  GradientButton.swift
//  Asthm App
//
//  Created by Den Matiash on 19.02.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation
import UIKit

class GradientButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    private func setupView() {
        layer.run {
            $0.masksToBounds = true
            $0.cornerRadius = 20
        }
        titleLabel?.font = Font.smallHeaderBold
        contentEdgeInsets = .init(top: 18, left: 54, bottom: 18, right: 54)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addLinearGradient(Palette.cyanBlue, Palette.cyan, .horizontal)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
