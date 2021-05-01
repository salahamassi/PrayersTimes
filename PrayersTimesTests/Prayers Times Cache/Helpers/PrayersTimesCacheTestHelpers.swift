//
//  PrayersTimesCacheTestHelpers.swift
//  PrayersTimesTests
//
//  Created by Salah Amassi on 23/04/2021.
//

import Foundation

extension Date {
    
    func adding(day: Int, using calendar: Calendar) -> Date {
        calendar.date(byAdding: .day, value: day, to: self)!
    }
    
    func adding(month: Int) -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: .month, value: month, to: self)!
    }
    
    func adding(seconds: TimeInterval) -> Date {
        return self + seconds
    }
    
    var startOfMonth: Date {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month], from: self)
        let startOfMonth = calendar.date(from: components)
        return startOfMonth ?? self
    }
    
    var endOfMonth: Date {
        let calendar = Calendar(identifier: .gregorian)
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return calendar.date(byAdding: components, to: startOfMonth) ?? self
    }
}
