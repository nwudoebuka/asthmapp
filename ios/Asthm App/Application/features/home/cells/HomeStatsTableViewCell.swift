//
//  HomeStatsTableViewCell.swift
//  Asthm App
//
//  Created by Den Matiash on 21.01.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation
import UIKit

class HomeStatsTableViewCell: UITableViewCell {
    
    private let cardView = CardView()
    private let titleLabel = BigHeaderBoldLabel()
    private let periodLabel = BodyLabel().apply {
        $0.textColor = Palette.royalBlue
    }
    private let barChart = BarChart()
    private let horizontalLine = UIView().apply {
        $0.backgroundColor = Palette.slateGray
        $0.alpha = 0.1
    }
    private let circleChart = CircleChartWithDescription()
    
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
        addSubview(cardView)
        [titleLabel, periodLabel, barChart,
         horizontalLine, circleChart].forEach(cardView.addSubview)
    }
    
    private func setConstraints() {
        cardView.edgesToSuperview(insets: .init(top: 6, left: 16, bottom: 6, right: 16))
        titleLabel.run {
            $0.leadingToSuperview(offset: 12)
            $0.topToSuperview(offset: 16)
        }
        periodLabel.run {
            $0.centerY(to: titleLabel)
            $0.trailingToSuperview(offset: 12)
        }
        barChart.run {
            $0.topToBottom(of: periodLabel, offset: 8)
            $0.height(340)
            $0.horizontalToSuperview(insets: .horizontal(12))
        }
        horizontalLine.run {
            $0.height(1)
            $0.topToBottom(of: barChart)
            $0.horizontalToSuperview()
        }
        circleChart.run {
            $0.height(180)
            $0.topToBottom(of: horizontalLine)
            $0.horizontalToSuperview()
            $0.bottomToSuperview()
        }
    }
    
    func bind(_ item: HomeItem.StatsItem) {
        titleLabel.text = item.title
        periodLabel.text = item.period
        barChart.bind(item)
        circleChart.bind(item)
    }
}
