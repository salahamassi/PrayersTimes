//
//  PrayersTimesCachePolicy.swift
//  PrayersTimes
//
//  Created by Salah Amassi on 23/04/2021.
//

import Foundation
 
final class PrayersTimesCachePolicy {
    
    static func validate(_ timestamp: Date, against data: Date) -> Bool {
        let calendar = Calendar(identifier: .gregorian)
        return calendar.isDate(data, equalTo: timestamp, toGranularity: .month)
    }
}
