//
//  CardViewWithRightArrow.swift
//  Asthm App
//
//  Created by Den Matiash on 20.01.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation
import UIKit

class CardViewWithRightArrow: CardView {
    
    struct UIModel {
        let text: String
        let imageView: UIImage?
        let color: UIColor
        let font: UIFont
        let isActionable: Bool
    }
    
    private let stackView = UIStackView().apply {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.spacing = 8
    }
    private let imageView = UIImageView()
    private let label = UILabel()
    private let chevronIcon = UIImageView(image: UIImage(named: "ic_chevron_right")?.withRenderingMode(.alwaysTemplate))
    
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
        addSubview(stackView)
        label.apply{
            $0.numberOfLines = 0
        }
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)
        addSubview(chevronIcon)
    }
    
    private func setConstraints() {
        imageView.run {
            $0.width(24)
            $0.height(24)
        }
        stackView.run {
            $0.leadingToSuperview(offset: 12)
            $0.verticalToSuperview(insets: .vertical(8))
            $0.trailingToLeading(of: chevronIcon, offset: -12, relation: .equalOrLess)
        }
        
        chevronIcon.run {
            $0.width(28)
            $0.height(28)
            $0.centerYToSuperview()
            $0.trailingToSuperview()
        }
    }
    
    func bind(_ uiModel: UIModel) {
        imageView.image = uiModel.imageView
        imageView.isHidden = uiModel.imageView == nil
        
        label.run {
            $0.text = uiModel.text
            $0.textColor = uiModel.color
            $0.font = uiModel.font
            $0.numberOfLines = 0
        }
        chevronIcon.tintColor = uiModel.color
        chevronIcon.isHidden = !uiModel.isActionable
    }
}
