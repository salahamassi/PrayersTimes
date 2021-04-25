//
//  SwiftyPrayerTime.swift
//  PrayersTimes
//
//  Created by Salah Amassi on 25/04/2021.
//

import Foundation

public struct SwiftyPrayerTime {
  
    public let date: Date
    public let type: PrayerType
    
    public init(date: Date, type: PrayerType) {
        self.date = date
        self.type = type
    }
}

