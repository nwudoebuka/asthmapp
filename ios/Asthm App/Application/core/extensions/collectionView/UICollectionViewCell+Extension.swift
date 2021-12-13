//
//  UICollectionViewCell+Extension.swift
//  Asthm App
//
//  Created by Den Matiash on 26.01.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionViewCell {

    class var nibName: String {
        return String(describing: self)
    }

    class var reuseIdentifier: String {
        return String(describing: self)
    }

    class func register(to collectionView: UICollectionView) {
        collectionView.register(UINib.init(nibName: self.nibName, bundle: nil), forCellWithReuseIdentifier: self.reuseIdentifier)
    }
}
