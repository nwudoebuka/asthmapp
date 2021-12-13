//
//  AddDataTableViewAdapter.swift
//  Asthm App
//
//  Created by Den Matiash on 14.01.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation
import UIKit

class AddDataTableViewAdapter: NSObject {
    
    var items: [AddDataItem] = []
    var onHintTap: (_ link: String) -> () = { _ in }
}

extension AddDataTableViewAdapter: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch(items[indexPath.row]) {
        case .measure(let uiModel):
            return tableView.dequeueReusableCell(cellType: AddDataMeasureTableViewCell.self).apply {
                $0.bind(uiModel) {
                    if let infoLink = uiModel.linkText {
                        self.onHintTap(infoLink)
                    }
                }
            }
        case .nextReview(let uiModel):
            return tableView.dequeueReusableCell(cellType: AddDataNextReviewTableViewCell.self).apply {
                $0.bind(uiModel)
            }
        case .puffs(let uiModel):
            return tableView.dequeueReusableCell(cellType: AddDataPuffsTableViewCell.self).apply {
                $0.bind(uiModel) {
                    self.onHintTap(uiModel.infoLink)
                }
            }
        }
    }
}

extension AddDataTableViewAdapter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
