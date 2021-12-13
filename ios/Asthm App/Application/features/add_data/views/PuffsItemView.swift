//
//  PuffsItemView.swift
//  Asthm App
//
//  Created by Den Matiash on 17.01.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation
import UIKit

class PuffsItemView: UIView {
    
    private let label = BodyLabel()
    private let counterView = CounterView()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    private func setupView() {
        buildViewTree()
        setConstraints()
    }
    
    private func buildViewTree() {
        [label, counterView].forEach(addSubview)
    }
    
    private func setConstraints() {
        label.run {
            $0.centerY(to: counterView)
            $0.leadingToSuperview()
        }
        counterView.run {
            $0.verticalToSuperview(insets: .vertical(4))
            $0.width(120)
            $0.trailingToSuperview()
        }
    }
    
    func bind(_ item: AddDataItem.PuffsUIModel.Item) {
        label.text = item.title
        counterView.bind(item)
    }
}
