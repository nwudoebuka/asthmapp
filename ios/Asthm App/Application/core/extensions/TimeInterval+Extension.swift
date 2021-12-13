//
//  TimeInterval+Extension.swift
//  Asthm App
//
//  Created by Den Matiash on 03.02.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation

extension TimeInterval {

    var socialDate: String? {
        return DateComponentsFormatter().apply {
            $0.allowedUnits = [.year, .month, .weekday, .day, .hour, .minute, .second]
            $0.unitsStyle = .full
            $0.maximumUnitCount = 1
        }.string(from: self)
    }
}
