//
//  LearnVideoTableViewCell.swift
//  Asthm App
//
//  Created by Den Matiash on 04.01.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class LearnVideoTableViewCell: UITableViewCell {
    
    private let cardView = CardView()
    private let thumbnailImage = UIImageView().apply {
        $0.contentMode = .scaleAspectFill
        $0.layer.masksToBounds = true
    }
    private let playIcon = UIImageView(image: UIImage(named: "ic_play"))
    private let titleLabel = BigBodyLabel()
    private let timeLabel = SubtitleLabel().apply {
        $0.textColor = Palette.royalBlue
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
        [thumbnailImage, titleLabel, timeLabel].forEach { cardView.addSubview($0) }
        thumbnailImage.addSubview(playIcon)
    }
    
    private func setConstraints() {
        cardView.edgesToSuperview(insets: UIEdgeInsets(top: 6, left: 16, bottom: 6, right: 16))
        
        thumbnailImage.run {
            $0.heightToWidth(of: thumbnailImage, multiplier: 9 / 16.0)
            $0.edgesToSuperview(excluding: .bottom)
        }
        
        playIcon.run {
            $0.width(38)
            $0.height(38)
            $0.centerInSuperview()
        }
        
        titleLabel.run {
            $0.topToBottom(of: thumbnailImage, offset: 8)
            $0.horizontalToSuperview(insets: .horizontal(12))
        }
        
        timeLabel.run {
            $0.leadingToSuperview(offset: 12)
            $0.topToBottom(of: titleLabel, offset: 40)
            $0.bottomToSuperview(offset: -12)
        }
    }
    
    func bind(_ video: LearnNewsItem.Video) {
        thumbnailImage.sd_setImage(with: URL(string: video.imageLink))
        titleLabel.text = video.title
        timeLabel.text = video.durationString
    }
}
