//
//  SubtitleLabel.swift
//  Asthm App
//
//  Created by Den Matiash on 06.01.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation
import UIKit

class SubtitleLabel: UILabel {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        font = Font.subtitle
        textColor = Palette.slateGray
        numberOfLines = 0
    }
}
