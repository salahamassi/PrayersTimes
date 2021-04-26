//
//  PrayersTimesCacheTestHelpers.swift
//  PrayersTimesTests
//
//  Created by Salah Amassi on 23/04/2021.
//

import Foundation
import PrayersTimes


let staticDate = Date(timeIntervalSince1970: 1619298000)

func uniqueItem(using date: Date = staticDate) -> PrayersTimes {
    .init(prayers: (fajr: getDate(from: "05:01 (EEST)", using: date),
                    sunrise: getDate(from: "06:30 (EEST)", using: date),
                    dhuhr: getDate(from: "12:46 (EEST)", using: date),
                    asr: getDate(from: "16:18 (EEST)", using: date),
                    sunset: getDate(from: "19:02 (EEST)", using: date),
                    maghrib: getDate(from: "19:02 (EEST)", using: date),
                    isha: getDate(from: "20:22 (EEST)", using: date),
                    imsak: getDate(from: "04:50 (EEST)", using: date),
                    midnight: getDate(from: "00:46 (EEST)", using: date)),
          for: date)
}

func uniqueItems() -> (models: [PrayersTimes], local: [LocalPrayersTimes]) {
    let models = [uniqueItem(), uniqueItem()]
    let local = models.map{ LocalPrayersTimes(prayers: (fajr: $0.prayers[.fajr],
                                                        sunrise: $0.prayers[.sunrise],
                                                        dhuhr: $0.prayers[.dhuhr],
                                                        asr: $0.prayers[.asr],
                                                        sunset: $0.prayers[.sunset],
                                                        maghrib: $0.prayers[.maghrib],
                                                        isha: $0.prayers[.isha],
                                                        imsak: $0.prayers[.imsak],
                                                        midnight: $0.prayers[.midnight]),
                                              for: $0.day) }
    return (models, local)
}

func getDate(from string: String, using date: Date) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/dd/yyyy"
    let fullDateString = dateFormatter.string(from: date)
    
    dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss"
    
    var stringResultDate = ""
    let splitResult = string.split(separator: " ")
    
    if let first = splitResult.first, let last = splitResult.last {
        dateFormatter.timeZone = TimeZone(abbreviation: String(last))
        stringResultDate.append(fullDateString)
        stringResultDate.append(" \(first):00")
        if let resultDate = dateFormatter.date(from: stringResultDate) {
            return resultDate
        }
    }
    fatalError("wrong string format \(string)")
}

extension Date {
    
    func adding(day: Int) -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: .day, value: day, to: self)!
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
