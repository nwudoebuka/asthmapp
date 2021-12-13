//
//  UIBarButtonItemWithText.swift
//  Asthm App
//
//  Created by Den Matiash on 14.01.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation
import UIKit

class UIBarButtonItemWithText: UIBarButtonItem {
    
    private let label = BigBodyLabel()

    override init() {
        super.init()
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    private func setupView() {
        customView = label
    }
    
    func bind(_ text: String, _ textColor: UIColor = Palette.ebonyClay) {
        label.text = text
        label.textColor = textColor
    }
}
