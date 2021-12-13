//
//  MoreTableViewAdapter.swift
//  Asthm App
//
//  Created by Alla Dubovska on 21.01.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation
import UIKit
import common

class MoreTableViewAdapter: NSObject {

    var items: [MoreItem] = []
    var onAddNewTap: () -> () = {}
    var onBuddyTap: (Buddy) -> () = { _ in }
    var onProfileTap: () -> () = {}
    var onEmergencyTap: () -> () = {}
}

extension MoreTableViewAdapter: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { items.count }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch items[indexPath.row] {
        case .emergency:
            return tableView.dequeueReusableCell(cellType: EmergencyTableViewCell.self)
        case .buddies(let buddies):
            return tableView.dequeueReusableCell(cellType: BuddiesTableViewCell.self).apply {
                $0.bind(
                    buddies,
                    onAddNewTap: {
                        self.onAddNewTap()
                    },
                    onBuddyTap: { buddy in
                        self.onBuddyTap(buddy)
                    }
                )
            }
        case .settings:
            let cell = tableView.dequeueReusableCell(cellType: MoreTableViewCell.self)
            cell.bind(CardViewWithRightArrow.UIModel(
                text: "settings".localized,
                imageView: UIImage(named: "ic_settings"),
                color: Palette.ebonyClay,
                font: Font.bigBody,
                isActionable: true
            ))
            return cell
        case .account:
            let cell = tableView.dequeueReusableCell(cellType: MoreTableViewCell.self)
            cell.bind(CardViewWithRightArrow.UIModel(
                text: "my_account".localized,
                imageView: UIImage(named: "ic_profile"),
                color: Palette.ebonyClay,
                font: Font.bigBody,
                isActionable: true
            ))
            return cell
        }
    }
}

extension MoreTableViewAdapter: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch items[indexPath.row] {
        case .account:
            onProfileTap()
        case .emergency:
            onEmergencyTap()
        default:
            break
        }
    }
}
