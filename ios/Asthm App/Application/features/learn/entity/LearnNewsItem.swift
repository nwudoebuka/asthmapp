//
//  LearnNewsItem.swift
//  Asthm App
//
//  Created by Den Matiash on 04.01.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation
import common

enum LearnNewsItem {
    
    struct Video {
        
        let title: String
        let link: String
        let imageLink: String
        let durationString: String
        
        init(_ video: LearnNews.Video) {
            title = video.title
            link = video.link
            imageLink = video.imageLink
            durationString = video.durationSeconds.toDurationString()
        }
    }
    
    struct Article {
        
        let title: String
        let link: String
        let imageLink: String
        let readDurationString: String
        
        init(_ article: LearnNews.Article) {
            title = article.title
            link = article.link
            imageLink = article.imageLink
            readDurationString = article.readTimeSeconds.toReadDurationString()
        }
    }
    
    case video(Video)
    case article(Article)
    case emergency
    case search
}

fileprivate extension Int32 {

    func toDurationString() -> String {
        let seconds = self % 60
        let minutes = self / 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func toReadDurationString() -> String {
        let minutes = self / 60
        return "article_read".localizedFormat(args: minutes)
    }
}
