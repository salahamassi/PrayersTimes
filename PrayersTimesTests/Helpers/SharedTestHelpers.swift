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

func prayersTimes(using date: Date = staticDate, timeZone: TimeZone) -> PrayersTimes {
    .init(prayers: (fajr: getDate(from: "05:01 (EEST)", using: date, and: timeZone),
                    sunrise: getDate(from: "06:30 (EEST)", using: date, and: timeZone),
                    dhuhr: getDate(from: "12:46 (EEST)", using: date, and: timeZone),
                    asr: getDate(from: "16:18 (EEST)", using: date, and: timeZone),
                    sunset: getDate(from: "19:02 (EEST)", using: date, and: timeZone),
                    maghrib: getDate(from: "19:02 (EEST)", using: date, and: timeZone),
                    isha: getDate(from: "20:22 (EEST)", using: date, and: timeZone),
                    imsak: getDate(from: "04:50 (EEST)", using: date, and: timeZone),
                    midnight: getDate(from: "00:46 (EEST)", using: date, and: timeZone)),
          for: date)
}

func prayersTimesArray(using timeZone: TimeZone) -> (models: [PrayersTimes], local: [LocalPrayersTimes]) {
    let models = [prayersTimes(timeZone: timeZone), prayersTimes(timeZone: timeZone)]
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

func getDate(from string: String, using date: Date, and timeZone: TimeZone) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/dd/yyyy"
    dateFormatter.timeZone = timeZone
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
