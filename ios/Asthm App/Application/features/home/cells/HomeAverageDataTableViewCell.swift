//
//  HomeAverageDataTableViewCell.swift
//  Asthm App
//
//  Created by Den Matiash on 20.01.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation
import UIKit

class HomeAverageDataTableViewCell: UITableViewCell {
    
    private let stackView = UIStackView().apply {
        $0.axis = .horizontal
        $0.spacing = 12
        $0.distribution = .fillEqually
    }
    private let leftView = AverageDataCardView()
    private let rightView = AverageDataCardView()
    
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
    }
    
    private func buildViewTree() {
        addSubview(stackView)
        stackView.addArrangedSubview(leftView)
        stackView.addArrangedSubview(rightView)
    }
    
    private func setConstraints() {
        stackView.edgesToSuperview(insets: .init(top: 8, left: 16, bottom: 8, right: 16))
    }
    
    func bind(_ item: HomeItem.AverageDataItem) {
        leftView.bind(item.leftUIModel)
        rightView.bind(item.rightUIModel)
    }
}
