//
//  CircleImageView.swift
//  Asthm App
//
//  Created by Den Matiash on 02.02.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation
import UIKit

class CircleImageView: UIImageView {
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = bounds.size.width / 2.0
    }
    
    private func setupView() {
        layer.masksToBounds = true
    }
}
