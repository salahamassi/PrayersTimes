//
//  SharedTestHelpers.swift
//  PrayersTimesTests
//
//  Created by Salah Amassi on 23/04/2021.
//

import Foundation
import PrayersTimes

func anyNSError() -> NSError {
    .init(domain: "any error", code: 0)
}

func anyURL() -> URL {
    URL(string: "http://any-url.com")!
}

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
    let local = models.map{ LocalPrayersTimes(prayers: (fajr: $0[.fajr].date,
                                                        sunrise: $0[.sunrise].date,
                                                        dhuhr: $0[.dhuhr].date,
                                                        asr: $0[.asr].date,
                                                        sunset: $0[.sunset].date,
                                                        maghrib: $0[.maghrib].date,
                                                        isha: $0[.isha].date,
                                                        imsak: $0[.imsak].date,
                                                        midnight: $0[.midnight].date),
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
