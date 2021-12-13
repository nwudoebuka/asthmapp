//
//  EmergencyTableViewCell.swift
//  Asthm App
//
//  Created by Den Matiash on 03.01.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation
import UIKit

class EmergencyTableViewCell: UITableViewCell {
    
    private let cardView = CardViewWithRightArrow()
    
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
        
        buildViewTree()
        setConstraints()
        setData()
    }
    
    private func buildViewTree() {
        addSubview(cardView)
    }
    
    private func setConstraints() {
        cardView.edgesToSuperview(insets: UIEdgeInsets(top: 8, left: 16, bottom: 4, right: 16))
    }
    
    private func setData() {
        cardView.bind(
            CardViewWithRightArrow.UIModel(
                text: "emergency".localized,
                imageView: nil,
                color: Palette.coralRed,
                font: Font.bigBody,
                isActionable: true
            )
        )
    }
}
