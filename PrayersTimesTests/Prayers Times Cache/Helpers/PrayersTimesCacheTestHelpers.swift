//
//  PrayersTimesCacheTestHelpers.swift
//  PrayersTimesTests
//
//  Created by Salah Amassi on 23/04/2021.
//

import Foundation
import PrayersTimes


let staticDate = Date(timeIntervalSince1970: 1619298000)

func uniqueItem() -> PrayersTimes {
    .init(fajr: "05:01 (EEST)",
          sunrise: "06:30 (EEST)",
          dhuhr: "12:46 (EEST)",
          asr: "16:18 (EEST)",
          sunset: "19:02 (EEST)",
          maghrib: "19:02 (EEST)",
          isha: "20:22 (EEST)",
          imsak: "04:50 (EEST)",
          midnight: "00:46 (EEST)",
          date: staticDate)
}

func uniqueItems() -> (models: [PrayersTimes], local: [LocalPrayersTimes]) {
    let models = [uniqueItem(), uniqueItem()]
    let local = models.map{ LocalPrayersTimes(fajr: $0.fajr,
                                             sunrise: $0.sunrise,
                                             dhuhr: $0.dhuhr,
                                             asr: $0.asr,
                                             sunset: $0.sunset,
                                             maghrib: $0.maghrib,
                                             isha: $0.isha,
                                             imsak: $0.imsak,
                                             midnight: $0.midnight,
                                             date: $0.date) }
    return (models, local)
}

extension Date {
   
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
