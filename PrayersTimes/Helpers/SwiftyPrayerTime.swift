//
//  SwiftyPrayerTime.swift
//  PrayersTimes
//
//  Created by Salah Amassi on 25/04/2021.
//

import Foundation

public struct SwiftyPrayerTime: Comparable {
  
    public let date: Date
    public let type: PrayersType
    
    public init(date: Date, type: PrayersType) {
        self.date = date
        self.type = type
    }
    
    public static func < (lhs: SwiftyPrayerTime, rhs: SwiftyPrayerTime) -> Bool {
        lhs.date < rhs.date
    }
}

