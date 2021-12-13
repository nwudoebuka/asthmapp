//
//  OnboardingItem.swift
//  Asthm App
//
//  Created by Den Matiash on 08.02.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation
import UIKit

enum OnboardingItem {
    
    struct StartItem {
        let backgroundImage: UIImage?
        let title: String
        let subtitle: String
    }
    
    struct AddDataItem {
        let backgroundImage: UIImage?
        let uiModel: OnboardingBottomCard.UIModel
    }
    
    struct InfoItem {
        let backgroundImage: UIImage?
        let uiModel: OnboardingBottomCard.UIModel
    }

    struct FinishItem {
        let backgroundImage: UIImage?
        let title: String
    }
    
    case start(StartItem)
    case addData(AddDataItem)
    case info(InfoItem)
    case finish(FinishItem)
}
