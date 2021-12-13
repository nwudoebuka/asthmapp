//
//  ReportsItem.swift
//  Asthm App
//
//  Created by Den Matiash on 28.01.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation
import common
import UIKit

enum ReportsItem {
    
    struct ReportUIModel {
        let title: String
        let items: [Item]
        let isShareEnabled: Bool
        let onShareTap: () -> ()
        
        struct Item {
            let title: String
            let subtitle: String
            let image: UIImage?
        }
    }
    
    case shareReport, report(ReportUIModel)
}
