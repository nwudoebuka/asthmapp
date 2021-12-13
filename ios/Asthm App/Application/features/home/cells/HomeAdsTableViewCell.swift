//
//  HomeAdsTableViewCell.swift
//  Asthm App
//
//  Created by Den Matiash on 20.01.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation
import UIKit

class HomeAdsTableViewCell: UITableViewCell {
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().apply {
        $0.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        $0.itemSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 108)
        $0.scrollDirection = .horizontal
    }).apply {
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
        $0.isPagingEnabled = true
    }
    private let pageControl = UIPageControl().apply {
        $0.currentPageIndicatorTintColor = Palette.royalBlue
        $0.pageIndicatorTintColor = Palette.white
    }
    private let collectionAdapter = HomeAdsCollectionViewAdapter()
    
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
        setupCollectionView()
    }
    
    private func buildViewTree() {
        addSubview(pageControl)
        addSubview(collectionView)
    }
    
    private func setConstraints() {
        collectionView.run {
            $0.topToSuperview(offset: 8)
            $0.horizontalToSuperview()
            $0.height(108)
        }
        
        pageControl.run {
            $0.topToBottom(of: collectionView)
            $0.bottomToSuperview()
            $0.centerXToSuperview()
        }
    }
    
    private func setupCollectionView() {
        collectionView.run {
            $0.delegate = collectionAdapter
            $0.dataSource = collectionAdapter
            $0.registerForReuse(cellType: HomeAdCollectionViewCell.self)
        }
        collectionAdapter.onScroll = { offsetX in
            self.updatePageControl(offsetX)
        }
    }
    
    private func updatePageControl(_ offsetX: CGFloat) {
        pageControl.currentPage = Int(round(offsetX / collectionView.frame.width))
    }
    
    func bind(_ item: HomeItem.AdsItem) {
        collectionAdapter.run {
            $0.items = item.uiModels
            $0.onTap = item.onTap
        }
        pageControl.run {
            $0.numberOfPages = item.uiModels.count
            $0.currentPage = 0
        }
        collectionView.reloadData()
    }
}
