//
//  BuddyUsersTableViewAdapter.swift
//  Asthm App
//
//  Created by Den Matiash on 17.02.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation
import UIKit
import common

class BuddyUsersTableViewAdapter: NSObject {
    
    var items: [BuddyUsersItem] = []
    var onUserTap: (Int) -> () = { _ in }
}

extension BuddyUsersTableViewAdapter: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch(items[indexPath.row]) {
        case .buddy(let uiModel):
            return tableView.dequeueReusableCell(cellType: BuddyUserTableViewCell.self).apply {
                $0.bind(uiModel)
            }
        case .noBuddies:
            return UITableViewCell(style: .default, reuseIdentifier: "noBuddies").apply {
                $0.selectionStyle = .none
                $0.backgroundColor = .clear
                $0.textLabel?.text = "no_buddies".localized
            }
        }
    }
}

extension BuddyUsersTableViewAdapter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onUserTap(indexPath.row)
    }
}
