//
//  CardView.swift
//  Asthm App
//
//  Created by Den Matiash on 04.01.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation
import UIKit

class CardView: UIView {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    private func setupView() {
        backgroundColor = Palette.white
        layer.masksToBounds = true
        layer.cornerRadius = 10
    }
}
