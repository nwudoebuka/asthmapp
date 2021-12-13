//
//  HomeTableViewAdapter.swift
//  Asthm App
//
//  Created by Den Matiash on 20.01.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation
import UIKit

class HomeTableViewAdapter: NSObject {
    
    var items: [HomeItem] = []
    var onReportsTap: () -> () = { }
    var onEmergencyTap: () -> () = { }
    var onCitationTap: () -> () = { }
}

extension HomeTableViewAdapter: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch(items[indexPath.row]) {
        case .emergency:
            return tableView.dequeueReusableCell(cellType: EmergencyTableViewCell.self)
        case .misc(let item):
            return tableView.dequeueReusableCell(cellType: HomeMiscTableViewCell.self).apply {
                $0.bind(item, onReportsTap: onReportsTap)
            }
        case .alert(let item):
            return tableView.dequeueReusableCell(cellType: HomeAlertTableViewCell.self).apply {
                $0.bind(item)
            }
        case .averageData(let item):
            return tableView.dequeueReusableCell(cellType: HomeAverageDataTableViewCell.self).apply {
                $0.bind(item)
            }
        case .ads(let item):
            return tableView.dequeueReusableCell(cellType: HomeAdsTableViewCell.self).apply {
                $0.bind(item)
            }
        case .stats(let item):
            return tableView.dequeueReusableCell(cellType: HomeStatsTableViewCell.self).apply {
                $0.bind(item)
            }
        case .citation:
            print("got to citattion")
            return tableView.dequeueReusableCell(cellType: CitataionTableViewCell.self)
        case .textCell:
            return tableView.dequeueReusableCell(cellType: TextTableViewCell.self)
        }
    }
}

extension HomeTableViewAdapter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if case .emergency = items[indexPath.row] {
            onEmergencyTap()
        }
        if case .citation = items[indexPath.row]{
            onCitationTap()
        }
    }
}
