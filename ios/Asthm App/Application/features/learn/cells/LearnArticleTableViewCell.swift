//
//  LearnArticleTableViewCell.swift
//  Asthm App
//
//  Created by Den Matiash on 04.01.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class LearnArticleTableViewCell: UITableViewCell {
    
    private let cardView = CardView()
    private let titleLabel = BigBodyLabel()
    private let timeLabel = SubtitleLabel().apply {
        $0.textColor = Palette.royalBlue
    }
    private let thumbnailImage = UIImageView().apply {
        $0.contentMode = .scaleAspectFill
        $0.layer.run {
            $0.cornerRadius = 10
            $0.masksToBounds = true
        }
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
    }
    
    private func buildViewTree() {
        addSubview(cardView)
        [titleLabel, timeLabel, thumbnailImage].forEach { cardView.addSubview($0) }
    }
    
    private func setConstraints() {
        cardView.run {
            $0.height(116)
            $0.edgesToSuperview(insets: UIEdgeInsets(top: 6, left: 16, bottom: 6, right: 16))
        }
        
        titleLabel.run {
            $0.topToSuperview(offset: 16)
            $0.leadingToSuperview(offset: 12)
            $0.trailingToLeading(of: thumbnailImage, offset: -8)
        }
        
        timeLabel.run {
            $0.leadingToSuperview(offset: 12)
            $0.bottomToSuperview(offset: -16)
        }
        
        thumbnailImage.run {
            $0.verticalToSuperview(insets: .vertical(18))
            $0.trailingToSuperview(offset: 12)
            $0.width(90)
        }
    }
    
    func bind(_ article: LearnNewsItem.Article) {
        titleLabel.text = article.title
        timeLabel.text = article.readDurationString
        thumbnailImage.sd_setImage(with: URL(string: article.imageLink))
    }
}
