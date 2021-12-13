//
//  Date+Extension.swift
//  Asthm App
//
//  Created by Den Matiash on 22.01.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation

extension Date {
    
    func plusDays(_ days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: self)!
    }
    
    var dayStart: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var monthStart: Date {
        let components = Calendar.current.dateComponents([.year, .month], from: dayStart)
        return Calendar.current.date(from: components)!
    }
}
