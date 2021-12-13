//
//  AddDataItem.swift
//  Asthm App
//
//  Created by Den Matiash on 14.01.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation
import UIKit
import common

enum AddDataItem {
    
    struct MeasureUIModel {
        let title: String
        let hint: String
        let linkText: String?
        let measureUnit: String
        let onDataChange: (String) -> ()
        let textFieldValidator: UITextFieldDelegate
        let value: Int?
        let linkTitle: String?
    }
    
    struct PuffsUIModel {
        let title: String
        let items: [Item]
        let infoLink: String
        
        struct Item {
            let title: String
            let onDataChange: (Int32) -> ()
            let validator: IValueValidator
            let value: Int32
        }
    }
    
    struct NextReviewUIModel {
        let title: String
        let onReminderSwitch: (Bool) -> ()
        let isReminderActivated: Bool
        let onScheduledReminderSet: (Int64) -> ()
    }
    
    case measure(MeasureUIModel), puffs(PuffsUIModel), nextReview(NextReviewUIModel)
}
