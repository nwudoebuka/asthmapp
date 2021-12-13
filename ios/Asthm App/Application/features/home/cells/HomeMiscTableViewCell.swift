//
//  HomeMiscTableViewCell.swift
//  Asthm App
//
//  Created by Den Matiash on 20.01.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation
import UIKit

class HomeMiscTableViewCell: UITableViewCell {

    private let stackView = UIStackView().apply {
        $0.axis = .horizontal
        $0.spacing = 12
        $0.distribution = .fillEqually
    }
    private let reportsView = ViewReportsCardView()
    private let rightView = AverageDataCardView()

    private var onReportsTap: () -> () = {}

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        selectionStyle = .none
        backgroundColor = .clear

        buildViewTree()
        setConstraints()
    }

    private func buildViewTree() {
        addSubview(stackView)
        stackView.addArrangedSubview(reportsView)
        stackView.addArrangedSubview(rightView)
    }

    private func setConstraints() {
        stackView.edgesToSuperview(insets: .init(top: 8, left: 16, bottom: 8, right: 16))
    }

    func bind(_ item: HomeItem.MiscItem, onReportsTap: @escaping () -> ()) {
        rightView.bind(item.uiModel)
        self.onReportsTap = onReportsTap

        reportsView.onTap(target: self, action: #selector(onReportsViewTap))
    }

    @objc private func onReportsViewTap() {
        onReportsTap()
    }
}
