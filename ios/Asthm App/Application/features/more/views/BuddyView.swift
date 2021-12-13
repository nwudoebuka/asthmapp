//
//  BuddyCell.swift
//  Asthm App
//
//  Created by Alla Dubovska on 21.01.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation
import UIKit
import TinyConstraints

class BuddyView: UIView {

    private let stackView = UIStackView().apply {
        $0.axis = .horizontal
        $0.spacing = 4
        $0.alignment = .center
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = .init(top: 0, left: 8, bottom: 0, right: 8)
    }

    private let nameLabel = BodyLabel().apply {
        $0.numberOfLines = 1
    }
    private let imageView = CircleImageView().apply {
        $0.image = UIImage(named: "ic_profile")
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        layer.borderWidth = 1
        layer.cornerRadius = 10

        buildViewTree()
        setConstraints()
    }

    private func buildViewTree() {
        [stackView].forEach(addSubview)
        [imageView, nameLabel].forEach { stackView.addArrangedSubview($0) }
    }

    private func setConstraints() {
        height(40)
        
        stackView.edgesToSuperview()
        
        imageView.run {
            $0.height(24)
            $0.width(24)
        }
    }
    
    struct UIModel {
        let image: UIImage?
        let name: String
        let textColor: UIColor
        let backgroundColor: UIColor
        let borderColor: UIColor?
    }

    func bind(_ uiModel: UIModel) {
        imageView.image = (uiModel.image == nil) ? UIImage(named: "ic_profile") : uiModel.image
        nameLabel.run {
            $0.text = uiModel.name
            $0.textColor = uiModel.textColor
        }
        backgroundColor = uiModel.backgroundColor
        layer.borderColor = uiModel.borderColor?.cgColor
    }
}
