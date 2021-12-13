//
//  CircleChartWithDescription.swift
//  Asthm App
//
//  Created by Den Matiash on 21.01.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation
import UIKit
import Charts

class CircleChartWithDescription: UIView {
    
    private let chart = PieChartView()
    private let stackView = UIStackView().apply {
        $0.spacing = 8
        $0.axis = .vertical
        $0.distribution = .equalSpacing
    }
    private let firstOption = LabelWithCircle()
    private let secondOption = LabelWithCircle()
    private let thirdOption = LabelWithCircle()
    
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
        setupChart()
    }
    
    private func buildViewTree() {
        [chart, stackView].forEach(addSubview)
        [firstOption, secondOption, thirdOption].forEach(stackView.addArrangedSubview)
    }
    
    private func setConstraints() {
        chart.run {
            $0.leadingToSuperview()
            $0.trailingToLeading(of: stackView)
            $0.verticalToSuperview()
        }
        stackView.run {
            $0.verticalToSuperview(insets: .vertical(24))
            $0.trailingToSuperview(offset: 12)
        }
    }
    
    private func setupChart() {
        chart.run {
            $0.usePercentValuesEnabled = true
            $0.chartDescription?.enabled = false
            $0.legend.enabled = false

            $0.dragDecelerationFrictionCoef = 0.95
            $0.drawHoleEnabled = true

            $0.holeColor = Palette.white

            $0.holeRadiusPercent = 0.85
            $0.transparentCircleRadiusPercent = 0

            $0.rotationAngle = 0.0
            $0.rotationEnabled = false
            $0.highlightPerTapEnabled = false

            $0.spin(duration: 3, fromAngle: 0, toAngle: 360, easingOption: .easeInOutQuad)
        }
    }
    
    private func setData(_ data: [Int]) {
        let entries = data.map { PieChartDataEntry(value: Double($0)) }
        let dataSet = PieChartDataSet(entries: entries).apply {
            $0.drawValuesEnabled = false
            $0.drawIconsEnabled = false
            $0.colors = [Palette.royalBlue, Palette.jordyBlue, Palette.hawkesBlue]
        }

        chart.data = PieChartData(dataSet: dataSet)
    }
    
    func bind(_ item: HomeItem.StatsItem) {
        firstOption.bind(LabelWithCircle.UIModel(
            circleColor: Palette.royalBlue,
            text: "preventer_inhaler_percents".localizedFormat(args: item.preventerInhaler)
        ))
        secondOption.bind(LabelWithCircle.UIModel(
            circleColor: Palette.jordyBlue,
            text: "reliever_inhaler_percents".localizedFormat(args: item.relieverInhaler)
        ))
        thirdOption.bind(LabelWithCircle.UIModel(
            circleColor: Palette.hawkesBlue,
            text: "combination_inhaler_percents".localizedFormat(args: item.combinationInhaler)
        ))
        setData([item.preventerInhaler, item.relieverInhaler, item.combinationInhaler])
    }
}
