//
//  LearnTableViewAdapter.swift
//  Asthm App
//
//  Created by Den Matiash on 04.01.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation
import UIKit

class LearnTableViewAdapter: NSObject {
    
    var items: [[LearnNewsItem]] = []
    var onTap: (_ link: String) -> () = { _ in }
    var onEmergencyTap: () -> () = { }
}

extension LearnTableViewAdapter: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch(items[indexPath.section][indexPath.row]) {
        case .article(let article):
            return tableView.dequeueReusableCell(cellType: LearnArticleTableViewCell.self).apply {
                $0.bind(article)
            }
        case .video(let video):
            return tableView.dequeueReusableCell(cellType: LearnVideoTableViewCell.self).apply {
                $0.bind(video)
            }
        case .emergency:
            return tableView.dequeueReusableCell(cellType: EmergencyTableViewCell.self)
        case .search:
            return tableView.dequeueReusableCell(cellType: LearnSearchTableViewCell.self)
        }
    }
}

extension LearnTableViewAdapter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch(items[indexPath.section][indexPath.row]) {
        case .video(let video):
            onTap(video.link)
        case .article(let article):
            onTap(article.link)
        case .emergency:
            onEmergencyTap()
        default:
            break
        }
    }
}
