//
//  BarChart.swift
//  Asthm App
//
//  Created by Den Matiash on 21.01.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation
import Charts
import UIKit
import common

class BarChart: UIView {
    
    private let chart = BarChartView()
    private lazy var charAdjuster = BarChartAdjuster(chart)
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        addSubview(chart)
        chart.edgesToSuperview(insets: .horizontal(12))
    }
    
    func bind(_ item: HomeItem.StatsItem) {
        charAdjuster.setPoints(generatePoints(item))
    }
    
    private func generatePoints(_ item: HomeItem.StatsItem) -> [(x: Double, y: Double)] {
        return item.weeklyPuffs.reversed().enumerated().map { index, value in
            return (x: Double(-index), y: Double(value))
        }.reversed()
    }
}
