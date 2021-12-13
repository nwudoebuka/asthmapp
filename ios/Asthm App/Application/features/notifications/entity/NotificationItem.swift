//
//  NotificationItem.swift
//  Asthm App
//
//  Created by Den Matiash on 03.01.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation
import common

enum NotificationItem {
    
    struct Notification {
        
        let message: String
        let time: String
        let type: common.Notification.Type_
        let link: String?
        
        init(notification: common.Notification) {
            message = notification.message
            time = notification.createdAt.buildAgoText()
            type = notification.type
            link = notification.link
        }
    }
    
    case notification(Notification)
    case emergency
}

fileprivate extension Int64 {
    
    func buildAgoText() -> String {
        guard let timePassed = TimeInterval((Int(Date().timeIntervalSince1970) - Int(self / 1000))).socialDate else { fatalError() }
        return "ago".localizedFormat(args: timePassed)
    }
}
