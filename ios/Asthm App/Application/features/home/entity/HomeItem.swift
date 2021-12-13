//
//  HomeItem.swift
//  Asthm App
//
//  Created by Den Matiash on 20.01.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation
import UIKit

enum HomeItem {
    
    struct MiscItem {
        let uiModel: AverageDataCardView.UIModel
    }
    
    struct AlertItem {
        let uiModel: CardViewWithRightArrow.UIModel
    }
    
    struct AverageDataItem {
        let leftUIModel: AverageDataCardView.UIModel
        let rightUIModel: AverageDataCardView.UIModel
    }
    
    struct AdsItem {
        let uiModels: [HomeAdCollectionViewCell.UIModel]
        let onTap: (_ link: String) -> ()
    }
    
    struct StatsItem {
        let title: String
        let period: String
        let weeklyPuffs: [Int]
        let preventerInhaler: Int
        let relieverInhaler: Int
        let combinationInhaler: Int
    }
    
    case emergency, citation,textCell,misc(MiscItem), alert(AlertItem), averageData(AverageDataItem), ads(AdsItem), stats(StatsItem)
    
}
