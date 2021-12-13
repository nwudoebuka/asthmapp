//
//  ProfileCardView.swift
//  Asthm App
//
//  Created by Den Matiash on 04.02.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation
import UIKit

class ProfileCardView: CardView {
    
    private let leftImageView = UIImageView().apply {
        $0.contentMode = .scaleAspectFill
        $0.layer.run {
            $0.masksToBounds = true
        }
    }
    private let circleView = CircleImageView().apply {
        $0.backgroundColor = Palette.solitude
    }
    private let label = UILabel()
    private let stackView = UIStackView().apply {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.spacing = 22
        $0.alignment = .center
    }
    private let rightImageView = UIImageView()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        buildViewTree()
        setConstraints()
    }
    
    private func buildViewTree() {
        [stackView, rightImageView].forEach(addSubview)
        stackView.addArrangedSubview(circleView)
        stackView.addArrangedSubview(label)
        
        circleView.addSubview(leftImageView)
    }
    
    private func setConstraints() {
        height(50)
        
        stackView.run {
            $0.leadingToSuperview(offset: 12)
            $0.verticalToSuperview()
            $0.trailingToLeading(of: rightImageView, offset: -12, relation: .equalOrLess)
        }
        circleView.run {
            $0.height(32)
            $0.width(32)
        }
        
        leftImageView.centerInSuperview()
        
        rightImageView.run {
            $0.height(20)
            $0.width(20)
            $0.centerYToSuperview()
            $0.trailingToSuperview(offset: 16)
        }
    }
    
    struct UIModel {
        let leftImage: UIImage?
        let text: String?
        let rightImage: UIImage?
        let font: UIFont
        let textColor: UIColor
    }
    
    func bind(_ uiModel: UIModel) {
        circleView.isHidden = uiModel.leftImage == nil
        leftImageView.image = uiModel.leftImage
        label.run {
            $0.text = uiModel.text
            $0.font = uiModel.font
            $0.textColor = uiModel.textColor
        }
        rightImageView.image = uiModel.rightImage
    }
}
