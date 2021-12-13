//
//  BuddiesCard.swift
//  Asthm App
//
//  Created by Alla Dubovska on 21.01.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation
import UIKit
import MaterialComponents.MDCButton
import TinyConstraints
import common

class BuddiesTableViewCell: UITableViewCell {

    private let cardView = CardView()
    private let title = BigBodyLabel().apply {
        $0.text = "my_buddies".localized
    }
    private let subtitle = SubtitleLabel().apply {
        var attributed = NSMutableAttributedString(string: "these_people_will_be_contacted_if_your_alert_mode_is_on".localized)
        attributed.append("learn_more".localized.underlined)
        $0.attributedText = attributed
    }
    private let addNewLabel = BigBodyLabel().apply {
        $0.textColor = Palette.colorPrimary
        $0.text = "add_new".localized
    }
    private let stackView = UIStackView().apply {
        $0.axis = .vertical
        $0.spacing = 8
        $0.distribution = .equalSpacing
    }
    private let buddiesSpacing = CGFloat(8)
    private let cardHorizontalInsets = CGFloat(16)
    private let stackViewHorizontalInsets = CGFloat(12)
    private var onAddNewTap: () -> () = {}
    private var onBuddyTap: (Buddy) -> () = { _ in }
    private var buddies: [Buddy] = []

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
        setInteractions()
    }

    private func buildViewTree() {
        addSubview(cardView)
        [title, addNewLabel, subtitle, stackView].forEach { cardView.addSubview($0) }
    }

    private func setConstraints() {
        cardView.edgesToSuperview(insets: UIEdgeInsets(top: 6, left: cardHorizontalInsets, bottom: 6, right: cardHorizontalInsets))
        title.run {
            $0.topToSuperview(offset: 12)
            $0.leadingToSuperview(offset: 12)
        }
        addNewLabel.run {
            $0.topToSuperview(offset: 12)
            $0.trailingToSuperview(offset: 12)
        }
        subtitle.run {
            $0.topToBottom(of: title, offset: 12)
            $0.leadingToSuperview(offset: 12)
            $0.trailingToSuperview(offset: 12)
        }
        stackView.run {
            $0.topToBottom(of: subtitle, offset: 12)
            $0.bottomToSuperview(offset: -12)
            $0.horizontalToSuperview(insets: .horizontal(stackViewHorizontalInsets))
        }
    }

    private func setInteractions() {
        addNewLabel.onTap(target: self, action: #selector(onAddNewClick))
    }

    @objc private func onAddNewClick() {
        onAddNewTap()
    }

    func bind(_ buddies: [Buddy], onAddNewTap: @escaping () -> (), onBuddyTap: @escaping (Buddy) -> ()) {
        resetBuddies()
        addBuddies(buddies)

        if buddies.count < Constants().MAX_AMOUNT_OF_BUDDIES {
            self.onAddNewTap = onAddNewTap
            addNewLabel.alpha = 1
        } else {
            self.onAddNewTap = {}
            addNewLabel.alpha = 0.5
        }
        self.onBuddyTap = onBuddyTap
    }

    private func resetBuddies() {
        stackView.arrangedSubviews.forEach { rowStackView in
            (rowStackView as! UIStackView).arrangedSubviews.forEach { $0.removeFromSuperview() }
            rowStackView.removeFromSuperview()
        }
    }

    private func addBuddies(_ buddies: [Buddy]) {
        self.buddies = buddies
        var widthOfCurrentRow = CGFloat(0)
        var currentRowStackView = addNewRow()

        buddies.enumerated().forEach { index, buddy in
            let cellWidth = buddy.fullName.size(
                withAttributes: [.font: UIFont.systemFont(ofSize: 14.0)]
            ).width + 24 + 16 + 4 + 2

            if widthOfCurrentRow + cellWidth + buddiesSpacing < UIScreen.main.bounds.width - 2 * (cardHorizontalInsets + stackViewHorizontalInsets) {
                widthOfCurrentRow += cellWidth + buddiesSpacing
            } else {
                widthOfCurrentRow = cellWidth + buddiesSpacing
                currentRowStackView.addArrangedSubview(buildSpacer())
                currentRowStackView = addNewRow()
            }
            currentRowStackView.addArrangedSubview(buildBuddyView(buddy, index))
        }

        currentRowStackView.addArrangedSubview(buildSpacer())
    }

    private func addNewRow() -> UIStackView {
        let rowStackView = UIStackView().apply {
            $0.axis = .horizontal
            $0.spacing = buddiesSpacing
            $0.distribution = .fill
        }
        stackView.addArrangedSubview(rowStackView)
        return rowStackView
    }

    private func buildBuddyView(_ buddy: Buddy, _ index: Int) -> BuddyView {
        let uiModel = BuddyView.UIModel(
            image: getImageFromBase64(buddy.avatar),
            name: buddy.fullName,
            textColor: Palette.ebonyClay,
            backgroundColor: Palette.white,
            borderColor: buddy.borderColor()
        )
        return BuddyView().apply {
            $0.tag = index
            $0.bind(uiModel)
            $0.onTap(target: self, action: #selector(onBuddyClick))
        }
    }

    @objc private func onBuddyClick(gestureRecognizer: UITapGestureRecognizer) {
        guard let index = gestureRecognizer.view?.tag else { return }
        onBuddyTap(buddies[index])
    }

    private func buildSpacer() -> UIView {
        UIView().apply { $0.setContentHuggingPriority(.defaultLow, for: .horizontal) }
    }

    private func getImageFromBase64(_ base64String: String?) -> UIImage? {
        guard let base64String = base64String else { return nil }
        guard let imageData = Data(base64Encoded: base64String) else { return nil }
        return UIImage(data: imageData)
    }
}

fileprivate extension Buddy {

    func borderColor() -> UIColor {
        switch status {
        case .pending:
            return Palette.silver
        case .accepted:
            return Palette.royalBlue
        case .rejected:
            return Palette.coralRed
        default:
            return Palette.silver
        }
    }
}
