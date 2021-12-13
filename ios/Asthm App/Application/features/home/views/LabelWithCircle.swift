//
//  LabelWithCircle.swift
//  Asthm App
//
//  Created by Den Matiash on 21.01.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation
import UIKit

class LabelWithCircle: UIView {
    
    private let circleView = UIImageView(image: UIImage(named: "ic_circle")?.withRenderingMode(.alwaysTemplate))
    private let label = BodyLabel()
    
    struct UIModel {
        let circleColor: UIColor
        let text: String
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        addSubview(circleView)
        addSubview(label)
        
        circleView.run {
            $0.width(20)
            $0.height(20)
            $0.topToSuperview()
            $0.leadingToSuperview()
        }
        
        label.run {
            $0.top(to: circleView)
            $0.leadingToTrailing(of: circleView, offset: 8)
            $0.trailingToSuperview()
            $0.bottomToSuperview()
        }
    }
    
    func bind(_ uiModel: UIModel) {
        circleView.tintColor = uiModel.circleColor
        label.text = uiModel.text
    }
}
