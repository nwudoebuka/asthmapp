//
//  CommonMaterialButton.swift
//  Asthm App
//
//  Created by Den Matiash on 29.01.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation
import UIKit
import MaterialComponents.MDCButton

class CommonMaterialButton: MDCButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        isUppercaseTitle = false
        backgroundColor = Palette.solitude
        setTitleColor(Palette.royalBlue, for: .normal)
        layer.cornerRadius = 8
    }
}
