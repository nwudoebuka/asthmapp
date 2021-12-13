//
//  BuddyUserTableViewCell.swift
//  Asthm App
//
//  Created by Den Matiash on 17.02.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation
import UIKit

class BuddyUserTableViewCell: UITableViewCell {
    
    private let cardView = CardView()
    private let label = SmallHeaderBoldLabel()
    private let statusImage = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    private func setupView() {
        selectionStyle = .none
        backgroundColor = .clear
        layer.cornerRadius = 10
        
        buildViewTree()
        setConstraints()
    }
    
    private func buildViewTree() {
        addSubview(cardView)
        [label, statusImage].forEach(cardView.addSubview)
    }
    
    private func setConstraints() {
        cardView.edgesToSuperview(insets: UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12))
        label.run {
            $0.leadingToSuperview(offset: 26)
            $0.verticalToSuperview(insets: .vertical(12))
        }
        statusImage.run {
            $0.centerYToSuperview()
            $0.trailingToSuperview(offset: 26)
        }
    }
    
    struct UIModel {
        let title: String?
        let image: UIImage?
    }
    
    func bind(_ uiModel: UIModel) {
        label.text = uiModel.title
        statusImage.image = uiModel.image
    }
}
