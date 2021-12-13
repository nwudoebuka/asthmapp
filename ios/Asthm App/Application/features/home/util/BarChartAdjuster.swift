//
//  BarChartAdjuster.swift
//  Asthm App
//
//  Created by Den Matiash on 22.01.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation
import UIKit
import Charts
import common

class BarChartAdjuster {
    
    private let chart: BarChartView
    
    init(_ chart: BarChartView) {
        self.chart = chart
        configureChart()
        configureAxisLeft()
        configureXAxis()
    }
    
    private func configureChart() {
        chart.run {
            $0.chartDescription = nil
            $0.legend.enabled = false
            $0.extraBottomOffset = 20
            $0.isUserInteractionEnabled = false
            $0.rightAxis.enabled = false
        }
    }
    
    private func configureAxisLeft() {
        chart.leftAxis.run {
            $0.axisMinimum = 0
            $0.enabled = true
            $0.granularity = 2
            $0.labelTextColor = Palette.slateGray
            $0.gridLineWidth = 0.4
        }
    }
    
    private func configureXAxis() {
        chart.xAxis.run {
            $0.enabled = true
            $0.labelCount = 4
            $0.yOffset = 10
            $0.valueFormatter = XAxisValueFormatter()
            $0.labelTextColor = Palette.slateGray
            $0.labelPosition = .bottom
            $0.drawGridLinesEnabled = false
        }
    }
    
    func setPoints(_ points: [(x: Double, y: Double)]) {
        let entries = points.map { BarChartDataEntry(x: $0.x, y: $0.y) }
        chart.data = BarChartData(dataSet: BarChartDataSet(entries: entries).apply {
            $0.drawValuesEnabled = false
        })
    }
}

class XAxisValueFormatter : IAxisValueFormatter {
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let currentDate = Date(timeIntervalSince1970: Double(DateUtils().startOfCurrentWeek() / 1000))
        
        let startDate = currentDate.plusDays(Int(value) * 7)
        let firstDay = Calendar.current.component(.day, from: startDate)
        
        let endDate = startDate.plusDays(6)
        let lastDay = Calendar.current.component(.day, from: endDate)

        let month = DateFormatter().apply { $0.dateFormat = "MMM" }.string(from: endDate)
        return "\(firstDay) - \(lastDay)\n\(month)"
    }
}
