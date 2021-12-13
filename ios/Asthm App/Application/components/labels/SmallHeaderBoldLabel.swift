//
//  SmallHeaderBoldLabel.swift
//  Asthm App
//
//  Created by Den Matiash on 16.02.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation
import UIKit

class SmallHeaderBoldLabel: UILabel {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        font = Font.smallHeaderBold
        textColor = Palette.ebonyClay
        numberOfLines = 0
    }
}
