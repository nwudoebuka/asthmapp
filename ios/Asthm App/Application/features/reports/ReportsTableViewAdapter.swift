//
//  ReportsTableViewAdapter.swift
//  Asthm App
//
//  Created by Den Matiash on 28.01.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation
import UIKit
import common

class ReportsTableViewAdapter: NSObject {
    
    var items: [ReportsItem] = []
    var onGetReportsTap: (Period) -> () = { _ in }
}

extension ReportsTableViewAdapter: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch(items[indexPath.row]) {
        case .shareReport:
            return tableView.dequeueReusableCell(cellType: ShareReportTableViewCell.self)
        case .report(let uiModel):
            return tableView.dequeueReusableCell(cellType: ReportTableViewCell.self).apply {
                $0.bind(uiModel)
            }
        }
    }
}

extension ReportsTableViewAdapter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if case .shareReport = items[indexPath.row] {
            onGetReportsTap(Period(type: .all, startInMillis: 0))
        }
    }
}
