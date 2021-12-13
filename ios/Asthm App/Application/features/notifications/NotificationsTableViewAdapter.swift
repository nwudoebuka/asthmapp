//
//  NotificationsTableViewAdapter.swift
//  Asthm App
//
//  Created by Den Matiash on 03.01.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation
import UIKit

class NotificationsTableViewAdapter: NSObject {
    
    var items: [NotificationItem] = []
    var shouldOpenLink: (String) -> () = { _ in }
    var shouldOpenAddData: () -> () = { }
    var onEmergencyTap: () -> () = { }
}

extension NotificationsTableViewAdapter: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch(items[indexPath.row]) {
        case .notification(let notification):
            return tableView.dequeueReusableCell(cellType: NotificationTableViewCell.self).apply {
                $0.bind(notification) {
                    if let link = notification.link {
                        self.shouldOpenLink(link)
                    }
                    if case .addData = notification.type {
                        self.shouldOpenAddData()
                    }
                }
            }
        case .emergency:
            return tableView.dequeueReusableCell(cellType: EmergencyTableViewCell.self)
        }
    }
}

extension NotificationsTableViewAdapter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if case .emergency = items[indexPath.row] {
            onEmergencyTap()
        }
    }
}
