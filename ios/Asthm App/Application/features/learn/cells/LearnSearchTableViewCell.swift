//
//  LearnSearchTableViewCell.swift
//  Asthm App
//
//  Created by Den Matiash on 05.01.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation
import UIKit
import common

class LearnSearchTableViewCell: UITableViewCell {
    
    private let cardView = CardView()
    private let searchIcon = UIImageView(image: UIImage(named: "ic_search")?.withRenderingMode(.alwaysTemplate)).apply {
        $0.tintColor = Palette.slateGray
    }
    private lazy var textField = UITextField().apply {
        $0.placeholder = "search_explanation".localized
        $0.clearButtonMode = .whileEditing
        $0.delegate = self
        $0.font = Font.body
        $0.textColor = Palette.ebonyClay
    }
    
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
        textField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
    }
    
    private func buildViewTree() {
        addSubview(cardView)
        cardView.addSubview(searchIcon)
        cardView.addSubview(textField)
    }
    
    private func setConstraints() {
        cardView.edgesToSuperview(insets: UIEdgeInsets(top: 10, left: 16, bottom: 26, right: 16))
        searchIcon.run {
            $0.width(24)
            $0.height(24)
            $0.centerY(to: textField)
            $0.leadingToSuperview(offset: 12)
        }
        textField.run {
            $0.leadingToTrailing(of: searchIcon, offset: 8)
            $0.trailingToSuperview(offset: 12)
            $0.verticalToSuperview(insets: .vertical(12))
        }
    }
    
    @objc private func textFieldDidChange(textField: UITextField) {
        store.dispatch(action: LearnRequests.FilterNews(query: textField.text ?? ""))
    }
}

extension LearnSearchTableViewCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       textField.resignFirstResponder()
       return true
    }
}
