//
//  HomeAdsCollectionViewAdapter.swift
//  Asthm App
//
//  Created by Den Matiash on 26.01.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation
import UIKit

class HomeAdsCollectionViewAdapter: NSObject {
    
    var items: [HomeAdCollectionViewCell.UIModel] = []
    var onTap: (_ link: String) -> () = { _ in }
    var onScroll: (_ offsetX: CGFloat) -> () = { _ in }
}

extension HomeAdsCollectionViewAdapter: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(cellType: HomeAdCollectionViewCell.self, for: indexPath).apply {
            $0.bind(items[indexPath.row])
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        onScroll(scrollView.contentOffset.x)
    }
}

extension HomeAdsCollectionViewAdapter: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onTap(items[indexPath.row].link)
    }
}
